class WorkoutMusicTrack {
  const WorkoutMusicTrack({
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });

  final String title;
  final String subtitle;
  final String assetPath;
}

const List<WorkoutMusicTrack> workoutMusicTracks = <WorkoutMusicTrack>[
  WorkoutMusicTrack(
    title: 'Cardio Pulse',
    subtitle: 'Steady 4/4 beat and synth lines, ideal for brisk walk, cycling, and full-body warm-up',
    assetPath: 'assets/workout_music/cardio_pulse.mp3',
  ),
  WorkoutMusicTrack(
    title: 'Power Engine',
    subtitle: 'Heavier drums and strong drive, great for squats, deadlifts, and strength circuits',
    assetPath: 'assets/workout_music/power_engine.mp3',
  ),
  WorkoutMusicTrack(
    title: 'Sprint Voltage',
    subtitle: 'Tight rhythm and clear intensity shifts, suitable for interval sprints and explosive HIIT moves',
    assetPath: 'assets/workout_music/sprint_voltage.mp3',
  ),
  WorkoutMusicTrack(
    title: 'Cooldown Mist',
    subtitle: 'Gentle atmosphere and low motion, suitable for cooldown, breathing, and static stretching',
    assetPath: 'assets/workout_music/cooldown_mist.mp3',
  ),
];
