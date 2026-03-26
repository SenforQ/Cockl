import 'package:flutter/material.dart';

import '../data/fitness_repository.dart';
import '../models/feed_comment.dart';
import 'profile_user_avatar.dart';

void showDiscoverCommentsSheet(
  BuildContext context, {
  required FitnessRepository repository,
  required String postId,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
        child: DiscoverCommentsSheet(
          repository: repository,
          postId: postId,
        ),
      );
    },
  );
}

class DiscoverCommentsSheet extends StatefulWidget {
  const DiscoverCommentsSheet({
    super.key,
    required this.repository,
    required this.postId,
  });

  final FitnessRepository repository;
  final String postId;

  @override
  State<DiscoverCommentsSheet> createState() => _DiscoverCommentsSheetState();
}

class _DiscoverCommentsSheetState extends State<DiscoverCommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final cardBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final handleColor = isDark ? const Color(0xFF48484A) : const Color(0xFFC7C7CC);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.72,
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 22),
                    visualDensity: VisualDensity.compact,
                  ),
                  Expanded(
                    child: Text(
                      'Comments',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.4,
                        color: isDark ? Colors.white : const Color(0xFF000000),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: isDark ? const Color(0xFF38383A) : const Color(0xFFC6C6C8)),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.repository,
                builder: (context, _) {
                  final items = widget.repository.commentsForPost(widget.postId);
                  if (items.isEmpty) {
                    return _EmptyComments(isDark: isDark);
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: isDark ? 10 : 8),
                    itemBuilder: (context, index) {
                      final c = items[index];
                      return _CommentTile(
                        comment: c,
                        repository: widget.repository,
                        cardBg: cardBg,
                        isDark: isDark,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              color: cardBg,
              padding: EdgeInsets.fromLTRB(
                12,
                10,
                12,
                10 + MediaQuery.paddingOf(context).bottom,
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: 'Say something...',
                          filled: true,
                          fillColor: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _send,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final text = _controller.text;
    await widget.repository.addComment(widget.postId, text);
    if (!mounted) {
      return;
    }
    _controller.clear();
    _focusNode.unfocus();
  }
}

class _EmptyComments extends StatelessWidget {
  const _EmptyComments({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 48,
              color: isDark ? const Color(0xFF8E8E93) : const Color(0xFFC7C7CC),
            ),
            const SizedBox(height: 16),
            Text(
              'No data',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No comments yet. Be the first to comment!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? const Color(0xFF636366) : const Color(0xFFAEAEB2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.repository,
    required this.cardBg,
    required this.isDark,
  });

  final FeedComment comment;
  final FitnessRepository repository;
  final Color cardBg;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final time = DateTime.fromMillisecondsSinceEpoch(comment.createdAtMillis);
    final timeStr =
        '${time.year.toString().padLeft(4, '0')}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    final isOwn = comment.isOwnComment;
    final displayName = isOwn ? repository.profileNickname : comment.authorName;

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isOwn)
              ProfileUserAvatar(repository: repository, radius: 18)
            else
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.person, size: 20, color: Theme.of(context).colorScheme.primary),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? Colors.white : const Color(0xFF000000),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    comment.body,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      color: isDark ? const Color(0xFFE5E5EA) : const Color(0xFF3A3A3C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
