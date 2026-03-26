class ProfileMetrics {
  const ProfileMetrics({
    required this.currentWeight,
    required this.monthlyWeightChange,
    required this.proteinAchievementRate,
  });

  final double currentWeight;
  final double monthlyWeightChange;
  final int proteinAchievementRate;

  ProfileMetrics copyWith({
    double? currentWeight,
    double? monthlyWeightChange,
    int? proteinAchievementRate,
  }) {
    return ProfileMetrics(
      currentWeight: currentWeight ?? this.currentWeight,
      monthlyWeightChange: monthlyWeightChange ?? this.monthlyWeightChange,
      proteinAchievementRate: proteinAchievementRate ?? this.proteinAchievementRate,
    );
  }
}
