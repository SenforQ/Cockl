import 'package:flutter/material.dart';

import '../data/fitness_repository.dart';
import '../data/today_workout_defaults.dart';

class WorkoutCheckInHistoryPage extends StatelessWidget {
  const WorkoutCheckInHistoryPage({super.key, required this.repository});

  final FitnessRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-in History'),
      ),
      body: AnimatedBuilder(
        animation: repository,
        builder: (context, _) {
          final days = repository.checkInHistoryDescending;
          if (days.isEmpty) {
            return const _EmptyCheckInPlaceholder();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final key = days[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.check_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(_formatCheckInDayLabel(key)),
                  subtitle: Text('Today Workout · ${TodayWorkoutDefaults.title}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

String _formatCheckInDayLabel(String key) {
  final dt = FitnessRepository.tryParseCalendarDayKey(key);
  if (dt == null) {
    return key;
  }
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${weekdays[dt.weekday - 1]}';
}

class _EmptyCheckInPlaceholder extends StatelessWidget {
  const _EmptyCheckInPlaceholder();

  static const String _placeholderAsset = 'assets/applogo.png';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.38,
              child: Image.asset(
                _placeholderAsset,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'No check-in records yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap "Complete Today Workout" on the workout home page, and your daily completion will appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
