/// Built-in workout cover assets (rotated by list order when no custom background is set).
class PlanCoverAssets {
  PlanCoverAssets._();

  static const List<String> defaultCovers = [
    'assets/workout/workout_hero.png',
    'assets/workout/workout_hiit.png',
    'assets/workout/workout_core.png',
    'assets/workout/workout_legs.png',
  ];

  static String assetForListIndex(int index) {
    if (defaultCovers.isEmpty) {
      return 'assets/workout/workout_hero.png';
    }
    return defaultCovers[index % defaultCovers.length];
  }
}
