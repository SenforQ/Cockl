import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/fitness_repository.dart';
import '../models/discover_post.dart';
import '../pages/report_page.dart';

Future<void> showDiscoverPostActionSheet(
  BuildContext context,
  FitnessRepository repository,
  DiscoverPost post,
) {
  return showCupertinoModalPopup<void>(
    context: context,
    builder: (sheetContext) {
      return CupertinoActionSheet(
        title: Text(
          post.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        message: Text(
          '@${post.user}',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ReportPage(post: post),
                ),
              );
            },
            child: const Text('Report'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(sheetContext);
              await repository.blockDiscoverUser(post.user);
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            child: const Text('Block User'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(sheetContext);
              await repository.blockDiscoverPost(post.id);
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            child: const Text('Hide Post'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(sheetContext),
          child: const Text('Cancel'),
        ),
      );
    },
  );
}
