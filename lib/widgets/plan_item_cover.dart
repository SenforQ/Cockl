import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/plan_cover_assets.dart';
import '../models/plan_item.dart';

/// Plan cover image: custom file or built-in asset + semi-transparent black overlay.
class PlanItemCover extends StatelessWidget {
  const PlanItemCover({
    super.key,
    required this.item,
    required this.listIndex,
    required this.height,
    this.borderRadius,
  });

  final PlanItem item;
  final int listIndex;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final rel = item.backgroundRelativePath;
    if (rel != null && rel.isNotEmpty) {
      return FutureBuilder<Directory>(
        future: getApplicationDocumentsDirectory(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return _loadingPlaceholder();
          }
          final file = File('${snap.data!.path}/$rel');
          if (!file.existsSync()) {
            return _assetStack(context, PlanCoverAssets.assetForListIndex(listIndex));
          }
          return _imageStack(
            context,
            Image.file(
              file,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
    return _assetStack(context, PlanCoverAssets.assetForListIndex(listIndex));
  }

  Widget _loadingPlaceholder() {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: const ColoredBox(
          color: Color(0xFF2D2D2D),
          child: Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _assetStack(BuildContext context, String assetPath) {
    return _imageStack(
      context,
      Image.asset(
        assetPath,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: SizedBox(
              height: height,
              width: double.infinity,
              child: Icon(
                Icons.fitness_center,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _imageStack(BuildContext context, Widget image) {
    final radius = borderRadius ?? BorderRadius.zero;
    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            image,
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
