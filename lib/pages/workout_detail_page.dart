import 'dart:async';

import 'package:flutter/material.dart';

import '../data/fitness_repository.dart';
import '../data/workout_music_catalog.dart';
import '../services/workout_music_service.dart';

class WorkoutDetailPage extends StatefulWidget {
  const WorkoutDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.calories,
    required this.level,
    this.repositoryForTodayCompletion,
  });

  final String title;
  final String subtitle;
  final String calories;
  final String level;
  final FitnessRepository? repositoryForTodayCompletion;

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  static const List<String> _stepTexts = [
    'Warm-up 5 min: dynamic stretching + light activation',
    'Main training: complete circuits based on class rhythm',
    'Cooldown 5 min: lower heart rate + lower-body stretching',
  ];

  late final List<int> _phaseSeconds;
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _sessionStarted = false;
  bool _running = false;
  bool _todayCompletionApplied = false;

  int get _totalSeconds => _phaseSeconds.fold(0, (a, b) => a + b);

  @override
  void initState() {
    super.initState();
    _phaseSeconds = _resolvePhaseSeconds(widget.title);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<int> _resolvePhaseSeconds(String title) {
    if (title.contains('HIIT')) {
      return const [180, 1020, 180];
    }
    if (title.contains('Core')) {
      return const [180, 540, 180];
    }
    if (title.contains('Legs') || title.contains('Glutes')) {
      return const [300, 1200, 300];
    }
    return const [300, 1080, 300];
  }

  int _activeStepIndex() {
    if (!_sessionStarted) {
      return -1;
    }
    if (_elapsedSeconds <= 0) {
      return 0;
    }
    var acc = 0;
    for (var i = 0; i < _phaseSeconds.length; i++) {
      acc += _phaseSeconds[i];
      if (_elapsedSeconds < acc) {
        return i;
      }
    }
    return _phaseSeconds.length;
  }

  int _phaseStartBoundary(int stepIndex) {
    var s = 0;
    for (var j = 0; j < stepIndex; j++) {
      s += _phaseSeconds[j];
    }
    return s;
  }

  int _secondsRemainingInPhase(int stepIndex) {
    if (stepIndex < 0 || stepIndex >= _phaseSeconds.length) {
      return 0;
    }
    final start = _phaseStartBoundary(stepIndex);
    final end = start + _phaseSeconds[stepIndex];
    return (end - _elapsedSeconds).clamp(0, _phaseSeconds[stepIndex]);
  }

  void _toggleRun() {
    if (_elapsedSeconds >= _totalSeconds) {
      setState(() {
        _elapsedSeconds = 0;
        _sessionStarted = false;
        _running = false;
      });
      _timer?.cancel();
      return;
    }
    setState(() {
      _sessionStarted = true;
      _running = !_running;
    });
    if (_running) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) {
          return;
        }
        final wasBelowTotal = _elapsedSeconds < _totalSeconds;
        setState(() {
          _elapsedSeconds += 1;
          if (_elapsedSeconds >= _totalSeconds) {
            _elapsedSeconds = _totalSeconds;
            _running = false;
            _timer?.cancel();
          }
        });
        if (wasBelowTotal &&
            _elapsedSeconds >= _totalSeconds &&
            _totalSeconds > 0) {
          _applyTodayCompletionIfNeeded();
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  void _applyTodayCompletionIfNeeded() {
    if (_todayCompletionApplied) {
      return;
    }
    if (widget.repositoryForTodayCompletion == null) {
      return;
    }
    _todayCompletionApplied = true;
    unawaited(_commitTodayCompletion(widget.repositoryForTodayCompletion!));
  }

  Future<void> _commitTodayCompletion(FitnessRepository repo) async {
    final wasAlreadyDone = repo.isTodayWorkoutComplete;
    await repo.completeTodayWorkout();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasAlreadyDone
              ? 'Workout timer finished · today check-in was already completed'
              : 'Workout completed · ${repo.todayWorkoutTitle} has been synced to check-in and home progress',
        ),
      ),
    );
  }

  Future<void> _promptAndPlayWorkoutMusic(BuildContext context) async {
    final svc = WorkoutMusicService.instance;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Workout Music & Background Playback'),
        content: const SingleChildScrollView(
          child: Text(
            'After enabling, music will start playing.\n\n'
            'Even if you temporarily leave the app, go to the home screen, or use other apps, music can continue in the background as long as the process is alive.\n\n'
            'Music is built into the app and can be played offline.',
            style: TextStyle(height: 1.45),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Enable and Play'),
          ),
        ],
      ),
    );
    if (!context.mounted) {
      return;
    }
    if (ok == true) {
      await svc.playCurrentTrack();
      if (context.mounted && svc.lastError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to play now: ${svc.lastError}')),
        );
      }
    }
  }

  Future<void> _onWorkoutMusicPlayPausePressed(BuildContext context) async {
    final svc = WorkoutMusicService.instance;
    if (svc.playing) {
      await svc.stopMusic();
      return;
    }
    if (svc.enabled) {
      await svc.resumeMusic();
      return;
    }
    await _promptAndPlayWorkoutMusic(context);
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Workout Timer Guide'),
        content: const SingleChildScrollView(
          child: Text(
            '• Tap "Start Workout" to begin total timer. You can pause anytime and continue later.\n\n'
            '• The top area shows elapsed total time. The active phase card is highlighted and shows remaining time.\n\n'
            '• Three phases run in order: Warm-up -> Main Training -> Cooldown. When one phase ends, the next phase is highlighted automatically.\n\n'
            '• After all phases finish, timer stops. Tap "Restart" to reset and start over.\n\n'
            '• Different session durations (HIIT, Core, Legs) automatically map to different main phase lengths.',
            style: TextStyle(height: 1.45),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatMmSs(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final active = _activeStepIndex();
    final finished = _sessionStarted && _elapsedSeconds >= _totalSeconds && _totalSeconds > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Guide',
            onPressed: _showHelp,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.repositoryForTodayCompletion != null) ...[
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tap "Start Workout" and wait until the full countdown ends to automatically complete today check-in and sync home progress.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Card(
            color: const Color(0xFFF3E8FF),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.subtitle),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      _Tag(text: widget.calories),
                      _Tag(text: widget.level),
                      const _Tag(text: 'Suggested 2-3 times/week'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: WorkoutMusicService.instance,
            builder: (context, _) {
              final svc = WorkoutMusicService.instance;
              final scheme = Theme.of(context).colorScheme;
              final open = svc.playing;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: open
                      ? scheme.primaryContainer.withValues(alpha: 0.65)
                      : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  border: Border.all(
                    width: open ? 2.5 : 1,
                    color: open ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.45),
                  ),
                  boxShadow: open
                      ? [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.28),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : const [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, open ? 18 : 14, 16, open ? 10 : 4),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 280),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: open ? scheme.primary : scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: open
                                  ? [
                                      BoxShadow(
                                        color: scheme.primary.withValues(alpha: 0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              Icons.graphic_eq_rounded,
                              color: open ? scheme.onPrimary : scheme.primary,
                              size: open ? 26 : 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Workout Music',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: open ? scheme.onPrimaryContainer : null,
                                      ),
                                ),
                                if (open) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    workoutMusicTracks[svc.selectedTrackIndex].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: scheme.onPrimaryContainer.withValues(alpha: 0.85),
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (open)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.music_note_rounded, color: scheme.onPrimary, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Playing',
                                    style: TextStyle(
                                      color: scheme.onPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (open)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: LinearProgressIndicator(
                          value: null,
                          minHeight: 3,
                          borderRadius: BorderRadius.circular(999),
                          backgroundColor: scheme.surface.withValues(alpha: 0.5),
                          color: scheme.primary,
                        ),
                      ),
                    _MusicTrackRadioTile(
                      value: 0,
                      groupValue: svc.selectedTrackIndex,
                      highlight: open && svc.selectedTrackIndex == 0,
                      scheme: scheme,
                      onPick: (v) {
                        if (v != null) {
                          WorkoutMusicService.instance.selectTrack(v);
                        }
                      },
                      title: workoutMusicTracks[0].title,
                      subtitle: workoutMusicTracks[0].subtitle,
                    ),
                    _MusicTrackRadioTile(
                      value: 1,
                      groupValue: svc.selectedTrackIndex,
                      highlight: open && svc.selectedTrackIndex == 1,
                      scheme: scheme,
                      onPick: (v) {
                        if (v != null) {
                          WorkoutMusicService.instance.selectTrack(v);
                        }
                      },
                      title: workoutMusicTracks[1].title,
                      subtitle: workoutMusicTracks[1].subtitle,
                    ),
                    _MusicTrackRadioTile(
                      value: 2,
                      groupValue: svc.selectedTrackIndex,
                      highlight: open && svc.selectedTrackIndex == 2,
                      scheme: scheme,
                      onPick: (v) {
                        if (v != null) {
                          WorkoutMusicService.instance.selectTrack(v);
                        }
                      },
                      title: workoutMusicTracks[2].title,
                      subtitle: workoutMusicTracks[2].subtitle,
                    ),
                    _MusicTrackRadioTile(
                      value: 3,
                      groupValue: svc.selectedTrackIndex,
                      highlight: open && svc.selectedTrackIndex == 3,
                      scheme: scheme,
                      onPick: (v) {
                        if (v != null) {
                          WorkoutMusicService.instance.selectTrack(v);
                        }
                      },
                      title: workoutMusicTracks[3].title,
                      subtitle: workoutMusicTracks[3].subtitle,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Music',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  svc.enabled && svc.playing
                                      ? 'Now playing: ${workoutMusicTracks[svc.selectedTrackIndex].title} · tap pause to restore default'
                                      : svc.enabled
                                          ? 'Tap play to resume'
                                          : 'Tap play to start (offline built-in audio)',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Tooltip(
                            message: svc.playing
                                ? 'Pause and restore default'
                                : svc.enabled
                                    ? 'Resume'
                                    : 'Play',
                            child: FilledButton(
                              onPressed: () {
                                unawaited(_onWorkoutMusicPlayPausePressed(context));
                              },
                              style: FilledButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(18),
                              ),
                              child: Icon(
                                svc.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (_sessionStarted) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            finished ? 'Workout Completed' : 'Workout In Progress',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total ${_formatMmSs(_elapsedSeconds)} / ${_formatMmSs(_totalSeconds)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (!finished && active >= 0 && active < _phaseSeconds.length) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Current Phase Remaining ${_formatMmSs(_secondsRemainingInPhase(active))}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'Workout Flow',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _stepTexts.length; i++)
            _StepTile(
              index: i + 1,
              text: _stepLabelForPhase(i),
              isActive: !finished && active == i,
              isCompleted: _sessionStarted && (active > i || finished),
              isPending: !_sessionStarted || active < i,
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _toggleRun,
            icon: Icon(
              finished
                  ? Icons.replay_rounded
                  : _running
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
            ),
            label: Text(
              finished
                  ? 'Restart'
                  : !_sessionStarted
                      ? 'Start Workout'
                      : _running
                          ? 'Pause'
                          : 'Resume',
            ),
          ),
        ],
      ),
    );
  }

  String _stepLabelForPhase(int phaseIndex) {
    final base = _stepTexts[phaseIndex];
    if (phaseIndex == 1) {
      final mainSec = _phaseSeconds[1];
      final mainMin = (mainSec / 60).round();
      return 'Main training about $mainMin min: complete circuits based on class rhythm';
    }
    return base;
  }
}

class _MusicTrackRadioTile extends StatelessWidget {
  const _MusicTrackRadioTile({
    required this.value,
    required this.groupValue,
    required this.highlight,
    required this.scheme,
    required this.onPick,
    required this.title,
    required this.subtitle,
  });

  final int value;
  final int groupValue;
  final bool highlight;
  final ColorScheme scheme;
  final void Function(int? v) onPick;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: highlight ? scheme.primary.withValues(alpha: 0.14) : Colors.transparent,
        border: Border.all(
          color: highlight ? scheme.primary.withValues(alpha: 0.65) : Colors.transparent,
          width: highlight ? 2 : 0,
        ),
      ),
      child: RadioListTile<int>(
        value: value,
        groupValue: groupValue,
        onChanged: onPick,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: highlight ? scheme.onSurface.withValues(alpha: 0.72) : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.index,
    required this.text,
    required this.isActive,
    required this.isCompleted,
    required this.isPending,
  });

  final int index;
  final String text;
  final bool isActive;
  final bool isCompleted;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Color bg;
    Color border;
    Color avatarBg;
    Color avatarFg;

    if (isActive) {
      bg = scheme.primaryContainer.withValues(alpha: 0.85);
      border = scheme.primary;
      avatarBg = scheme.primary;
      avatarFg = scheme.onPrimary;
    } else if (isCompleted) {
      bg = scheme.surfaceContainerHighest.withValues(alpha: 0.5);
      border = scheme.outlineVariant;
      avatarBg = scheme.tertiaryContainer;
      avatarFg = scheme.onTertiaryContainer;
    } else {
      bg = scheme.surface;
      border = scheme.outlineVariant.withValues(alpha: 0.5);
      avatarBg = const Color(0xFFEDE9FE);
      avatarFg = scheme.onSurface;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isActive ? 3 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: border, width: isActive ? 2 : 1),
      ),
      color: bg,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: avatarBg,
          foregroundColor: avatarFg,
          child: isCompleted && !isActive
              ? Icon(Icons.check_rounded, color: avatarFg, size: 22)
              : Text('$index', style: TextStyle(fontWeight: FontWeight.w700, color: avatarFg)),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isPending && !isActive ? scheme.onSurface.withValues(alpha: 0.65) : scheme.onSurface,
          ),
        ),
        subtitle: isActive
            ? Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Icon(Icons.play_circle_filled_rounded, size: 16, color: scheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'In Progress',
                      style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            : isCompleted && !isActive
                ? Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Completed',
                      style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
                    ),
                  )
                : null,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
