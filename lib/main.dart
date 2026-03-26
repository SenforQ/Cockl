import 'package:flutter/material.dart';

import 'app.dart';
import 'services/workout_music_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WorkoutMusicService.instance.ensureAudioSession();
  runApp(const FitnessApp());
}
