import 'package:flutter/material.dart';

import 'data/fitness_repository.dart';
import 'pages/root_page.dart';
import 'theme/app_theme.dart';

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  final FitnessRepository repository = FitnessRepository();
  late final Future<void> initializeFuture = repository.initialize();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializeFuture,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: snapshot.connectionState == ConnectionState.done
              ? FitnessRootPage(repository: repository)
              : const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        );
      },
    );
  }
}
