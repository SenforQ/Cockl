import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import '../data/fitness_repository.dart';

class ProfileUserAvatar extends StatelessWidget {
  const ProfileUserAvatar({
    super.key,
    required this.repository,
    this.radius = 28,
  });

  final FitnessRepository repository;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final rel = repository.profileAvatarRelativePath;
        if (rel == null || rel.isEmpty) {
          return CircleAvatar(
            radius: radius,
            backgroundImage: const AssetImage(AppConstants.defaultAvatarAsset),
          );
        }
        return FutureBuilder<Directory>(
          future: getApplicationDocumentsDirectory(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return CircleAvatar(
                radius: radius,
                child: SizedBox(
                  width: radius,
                  height: radius,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            final file = File('${snap.data!.path}/$rel');
            if (!file.existsSync()) {
              return CircleAvatar(
                radius: radius,
                backgroundImage: const AssetImage(AppConstants.defaultAvatarAsset),
              );
            }
            return CircleAvatar(
              radius: radius,
              backgroundImage: FileImage(file),
            );
          },
        );
      },
    );
  }
}
