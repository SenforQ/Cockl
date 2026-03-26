import 'package:flutter/material.dart';

import '../data/fitness_repository.dart';
import 'workout_check_in_history_page.dart';
import 'workout_detail_page.dart';

class WorkoutHomePage extends StatelessWidget {
  const WorkoutHomePage({super.key, required this.repository});

  final FitnessRepository repository;

  static const String _heroAsset = 'assets/workout/workout_hero.png';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        final progress = repository.todayProgress;
        final topInset = MediaQuery.paddingOf(context).top;
        const heroContentHeight = 268.0;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: heroContentHeight + topInset,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        _heroAsset,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.48),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        top: topInset + 10,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today Workout Overview',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              progress >= 1.0
                                  ? 'Today goal completed · ${repository.todayWorkoutTitle}'
                                  : 'Progress ${(progress * 100).round()}% · tap "Complete Today Workout" and finish the full timer to complete automatically',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.92),
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Today Session: ${repository.todayWorkoutTitle}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () => _openWorkoutDetail(
                                  context,
                                  title: repository.todayWorkoutTitle,
                                  subtitle: repository.todayWorkoutSubtitle,
                                  calories: repository.todayWorkoutCalories,
                                  level: repository.todayWorkoutLevel,
                                ),
                                child: const Text('Start Today Session'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                minHeight: 10,
                                value: progress.clamp(0.0, 1.0),
                                backgroundColor: const Color(0x44FFFFFF),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(height: 14),
                            FilledButton(
                              onPressed: () {
                                if (repository.isTodayWorkoutComplete) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Already checked in today · ${repository.todayWorkoutTitle}'),
                                    ),
                                  );
                                  return;
                                }
                                _openWorkoutDetail(
                                  context,
                                  title: repository.todayWorkoutTitle,
                                  subtitle: repository.todayWorkoutSubtitle,
                                  calories: repository.todayWorkoutCalories,
                                  level: repository.todayWorkoutLevel,
                                  repositoryForTodayCompletion: repository,
                                );
                              },
                              child: Text(
                                repository.isTodayWorkoutComplete ? 'Today Goal Completed' : 'Complete Today Workout',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'Recommended Sessions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  _WorkoutCard(
                    imageAsset: 'assets/workout/workout_hiit.png',
                    title: repository.todayWorkoutTitle,
                    subtitle: repository.todayWorkoutSubtitle,
                    calories: repository.todayWorkoutCalories,
                    level: repository.todayWorkoutLevel,
                    onTap: () => _openWorkoutDetail(
                      context,
                      title: repository.todayWorkoutTitle,
                      subtitle: repository.todayWorkoutSubtitle,
                      calories: repository.todayWorkoutCalories,
                      level: repository.todayWorkoutLevel,
                    ),
                  ),
                  _WorkoutCard(
                    imageAsset: 'assets/workout/workout_core.png',
                    title: 'Core Sculpt · 15 min',
                    subtitle: 'Abs and lower back stability',
                    calories: '~140 kcal',
                    level: 'Beginner',
                    onTap: () => _openWorkoutDetail(
                      context,
                      title: 'Core Sculpt · 15 min',
                      subtitle: 'Abs and lower back stability',
                      calories: '~140 kcal',
                      level: 'Beginner',
                    ),
                  ),
                  _WorkoutCard(
                    imageAsset: 'assets/workout/workout_legs.png',
                    title: 'Glutes & Legs Power · 30 min',
                    subtitle: 'Lower-body strength and explosiveness',
                    calories: '~320 kcal',
                    level: 'Intermediate',
                    onTap: () => _openWorkoutDetail(
                      context,
                      title: 'Glutes & Legs Power · 30 min',
                      subtitle: 'Lower-body strength and explosiveness',
                      calories: '~320 kcal',
                      level: 'Intermediate',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => WorkoutCheckInHistoryPage(repository: repository),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(Icons.local_fire_department, color: colorScheme.primary),
                      ),
                      title: Text('${repository.streakDays} Consecutive Check-in Days'),
                      subtitle: const Text('Tap to view daily check-in history'),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openWorkoutDetail(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String calories,
    required String level,
    FitnessRepository? repositoryForTodayCompletion,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WorkoutDetailPage(
          title: title,
          subtitle: subtitle,
          calories: calories,
          level: level,
          repositoryForTodayCompletion: repositoryForTodayCompletion,
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.calories,
    required this.level,
    required this.onTap,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
  final String calories;
  final String level;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.asset(
                  imageAsset,
                  height: 148,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Row(
                children: [
                  _Tag(text: calories),
                  const SizedBox(width: 8),
                  _Tag(text: level),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
