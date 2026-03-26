import 'package:flutter/material.dart';

import '../data/fitness_repository.dart';
import '../models/discover_post.dart';
import '../widgets/discover_comments_sheet.dart';
import '../widgets/discover_post_action_sheet.dart';
import 'discover_detail_page.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key, required this.repository});

  final FitnessRepository repository;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: repository,
        builder: (context, _) {
          final posts = repository.visibleDiscoverPosts;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Discover',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              if (posts.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 48, 8, 48),
                  child: Center(
                    child: Text(
                      'No content available',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
              ...posts.map(
                (post) => _DiscoverPost(
                  post: post,
                  repository: repository,
                  onLike: () => repository.toggleLike(post.id),
                  onBookmark: () => repository.toggleBookmark(post.id),
                  onOpen: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DiscoverDetailPage(
                          post: post,
                          repository: repository,
                        ),
                      ),
                    );
                  },
                  onOpenComments: () {
                    showDiscoverCommentsSheet(
                      context,
                      repository: repository,
                      postId: post.id,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DiscoverPost extends StatelessWidget {
  const _DiscoverPost({
    required this.post,
    required this.repository,
    required this.onLike,
    required this.onBookmark,
    required this.onOpen,
    required this.onOpenComments,
  });

  final DiscoverPost post;
  final FitnessRepository repository;
  final VoidCallback onLike;
  final VoidCallback onBookmark;
  final VoidCallback onOpen;
  final VoidCallback onOpenComments;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: onOpen,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 40, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ListAvatar(asset: post.avatarAsset),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.user, style: const TextStyle(fontWeight: FontWeight.w700)),
                                if (post.tags.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: post.tags
                                        .map(
                                          (t) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              t,
                                              style: Theme.of(context).textTheme.labelSmall,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(post.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      if (post.imageAssets.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.asset(
                              post.imageAssets.first,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                      if (post.quote.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          '「${post.quote}」',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onLike,
                      icon: Icon(
                        post.liked ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: post.liked ? Colors.pink.shade300 : Colors.pink.shade200,
                      ),
                    ),
                    Text('${post.likes}'),
                    const SizedBox(width: 4),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onOpenComments,
                        borderRadius: BorderRadius.circular(22),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.mode_comment_outlined, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text('${post.comments}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onBookmark,
                      icon: Icon(post.bookmarked ? Icons.bookmark : Icons.bookmark_border),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => showDiscoverPostActionSheet(context, repository, post),
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListAvatar extends StatelessWidget {
  const _ListAvatar({this.asset});

  final String? asset;

  @override
  Widget build(BuildContext context) {
    const double r = 20;
    if (asset == null || asset!.isEmpty) {
      return const CircleAvatar(radius: r, child: Icon(Icons.person, size: 20));
    }
    return CircleAvatar(
      radius: r,
      backgroundImage: AssetImage(asset!),
    );
  }
}
