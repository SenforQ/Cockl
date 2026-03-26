import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../data/fitness_repository.dart';
import '../models/discover_post.dart';
import '../widgets/discover_comments_sheet.dart';
import '../widgets/discover_post_action_sheet.dart';
import 'discover_video_fullscreen_page.dart';

class DiscoverDetailPage extends StatefulWidget {
  const DiscoverDetailPage({super.key, required this.post, required this.repository});

  final DiscoverPost post;
  final FitnessRepository repository;

  @override
  State<DiscoverDetailPage> createState() => _DiscoverDetailPageState();
}

class _DiscoverDetailPageState extends State<DiscoverDetailPage> {
  VideoPlayerController? _videoController;
  bool _videoLoadFailed = false;

  @override
  void initState() {
    super.initState();
    final path = widget.post.videoAsset;
    if (path != null && path.isNotEmpty) {
      final controller = VideoPlayerController.asset(path)..setLooping(true);
      _videoController = controller;
      controller.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      }).catchError((Object _) {
        if (_videoController == controller) {
          _videoController = null;
        }
        controller.dispose();
        if (mounted) {
          setState(() {
            _videoLoadFailed = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _openVideoFullscreen(BuildContext context) {
    final c = _videoController;
    if (c == null || !c.value.isInitialized) {
      return;
    }
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => DiscoverVideoFullscreenPage(controller: c),
      ),
    );
  }

  DiscoverPost _resolvedPost() {
    for (final item in widget.repository.discoverPosts) {
      if (item.id == widget.post.id) {
        return item;
      }
    }
    return widget.post;
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        final live = _resolvedPost();
        return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_rounded, color: Colors.black),
            tooltip: 'Report, block user, or hide post',
            onPressed: () {
              showDiscoverPostActionSheet(
                context,
                widget.repository,
                live,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(asset: post.avatarAsset),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: post.tags
                          .map(
                            (t) => Chip(
                              label: Text(t),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (post.imageAssets.isNotEmpty)
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: post.imageAssets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        post.imageAssets[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (post.imageAssets.isNotEmpty) const SizedBox(height: 16),
          if (_videoController != null && _videoController!.value.isInitialized)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workout Video',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(_videoController!),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.black.withValues(alpha: 0.45),
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: IconButton(
                              onPressed: () => _openVideoFullscreen(context),
                              icon: const Icon(Icons.fullscreen_rounded, color: Colors.white),
                              tooltip: 'Fullscreen',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_videoController!.value.isPlaying) {
                                _videoController!.pause();
                              } else {
                                _videoController!.play();
                              }
                            });
                          },
                          icon: Icon(
                            _videoController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            size: 56,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            )
          else if (post.videoAsset != null && post.videoAsset!.isNotEmpty && !_videoLoadFailed)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
          Text(
            post.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      post.quote.isEmpty ? 'Keep training and become a stronger you.' : post.quote,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Text(
            'Health & Workout Data',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          _HealthGrid(post: post),
          if (post.nutritionTip.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.restaurant_outlined),
                title: const Text('Nutrition Tip'),
                subtitle: Text(post.nutritionTip),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => widget.repository.toggleLike(live.id),
                    icon: Icon(
                      live.liked ? Icons.favorite : Icons.favorite_border,
                      color: live.liked ? Colors.pink.shade300 : Colors.pink.shade200,
                    ),
                  ),
                  Text('${live.likes}'),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        showDiscoverCommentsSheet(
                          context,
                          repository: widget.repository,
                          postId: live.id,
                        );
                      },
                      borderRadius: BorderRadius.circular(22),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mode_comment_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 6),
                            Text('${live.comments}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => widget.repository.toggleBookmark(live.id),
                    icon: Icon(live.bookmarked ? Icons.bookmark : Icons.bookmark_border),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.asset});

  final String? asset;

  @override
  Widget build(BuildContext context) {
    const double size = 52;
    if (asset == null || asset!.isEmpty) {
      return const CircleAvatar(
        radius: size / 2,
        child: Icon(Icons.person),
      );
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: AssetImage(asset!),
    );
  }
}

class _HealthGrid extends StatelessWidget {
  const _HealthGrid({required this.post});

  final DiscoverPost post;

  @override
  Widget build(BuildContext context) {
    final items = <_HealthCell>[
      _HealthCell('Weekly Workouts', '${post.weeklyWorkouts} sessions', Icons.fitness_center),
      _HealthCell('Daily Steps Avg', '${post.dailyStepAvg}', Icons.directions_walk),
      _HealthCell('Calorie Target', '${post.dailyCalorieTarget} kcal', Icons.local_fire_department_outlined),
      _HealthCell('Hydration Target', '${post.hydrationTargetMl} ml', Icons.water_drop_outlined),
      _HealthCell('Sleep Target', '${post.sleepHoursTarget.toStringAsFixed(1)} h', Icons.bedtime_outlined),
      _HealthCell('Resting Heart Rate', '${post.restingHeartRateBpm} bpm', Icons.favorite_outline),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: items
          .map(
            (cell) => Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cell.icon, size: 22, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 6),
                    Text(cell.label, style: Theme.of(context).textTheme.bodySmall),
                    Text(
                      cell.value,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _HealthCell {
  const _HealthCell(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}
