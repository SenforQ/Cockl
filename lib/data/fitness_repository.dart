import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import 'community_manifest.dart';
import 'today_workout_defaults.dart';
import '../models/discover_post.dart';
import '../models/feed_comment.dart';
import '../models/plan_item.dart';
import '../models/profile_metrics.dart';

class FitnessRepository extends ChangeNotifier {
  static const String keyStreak = 'fitness.streakDays';
  static const String keyDailyProgress = 'fitness.v2.dailyProgress';
  static const String keyDailyProgressDay = 'fitness.v2.dailyProgressDay';
  static const String keyLastCompleteDay = 'fitness.v2.lastCompleteDay';
  static const String keyCheckInHistory = 'fitness.v2.checkInHistory';
  static const String keyPlans = 'fitness.weekPlans';
  static const String keyPosts = 'fitness.discoverPosts';
  static const String keyWeight = 'fitness.currentWeight';
  static const String keyWeightChange = 'fitness.monthlyWeightChange';
  static const String keyProteinRate = 'fitness.proteinAchievementRate';
  static const String keyFeedComments = 'fitness.feedComments';
  static const String keyProfileNickname = 'profile.nickname';
  static const String keyProfileSignature = 'profile.signature';
  static const String keyProfileAvatarRelative = 'profile.avatarRelativePath';
  static const String keyWalletCoins = 'wallet.coins';
  static const String keyWalletProcessedPurchaseIds = 'wallet.processedPurchaseIds';
  static const String keyWalletLastWorkoutRewardDay = 'wallet.lastWorkoutRewardDay';
  static const String keyWalletNewUserGiftClaimed = 'wallet.newUserGiftClaimed';
  static const String keyBlockedPostIds = 'discover.blockedPostIds';
  static const String keyBlockedUserNames = 'discover.blockedUserNames';
  static const int planExtraLimitFreeCount = 7;
  static const int planExtraCostCoins = 20;
  static const int aiChatCostCoins = 1;
  static const int workoutDailyRewardCoins = 5;
  static const int streakBonusThresholdDays = 10;
  static const int streakBonusCoins = 50;
  static const int newUserGiftCoins = 5;

  late SharedPreferences _preferences;
  Map<String, List<FeedComment>> _feedCommentsByPostId = {};
  final Set<String> _blockedPostIds = {};
  final Set<String> _blockedUserNames = {};
  final Set<String> _processedWalletPurchaseIds = {};

  int streakDays = 0;
  double todayProgress = 0;
  List<String> checkInDayKeys = [];
  List<PlanItem> weekPlans = const [
    PlanItem(
      content: 'Upper Body Strength + Stretching',
      status: PlanStatus.completed,
      actions: ['Dynamic warm-up 8 min', 'Press/Row 4 sets', 'Stretch cooldown 10 min'],
    ),
    PlanItem(
      content: 'HIIT Interval Training',
      status: PlanStatus.completed,
      actions: ['Jumping jacks 2 min', 'Burpee/Squat circuit 6 sets', 'Cooldown walk 5 min'],
    ),
    PlanItem(
      content: 'Core Stability Training',
      status: PlanStatus.active,
      actions: ['Plank 3 sets', 'Dead bug 3 sets', 'Side plank 2 sets'],
    ),
    PlanItem(
      content: 'Active Recovery Walk',
      status: PlanStatus.pending,
      actions: ['Brisk walk 30 min', 'Lower-body stretching'],
    ),
    PlanItem(
      content: 'Lower Body Strength Training',
      status: PlanStatus.pending,
      actions: ['Squat/Deadlift 3 sets', 'Lunge 3 sets', 'Stretch cooldown'],
    ),
  ];
  List<DiscoverPost> discoverPosts = const [];
  ProfileMetrics profileMetrics = const ProfileMetrics(
    currentWeight: 68.2,
    monthlyWeightChange: -1.8,
    proteinAchievementRate: 86,
  );

  String profileNickname = AppConstants.projectName;
  String profileSignature = '';
  String? profileAvatarRelativePath;
  int walletCoins = 0;
  String? _lastWorkoutRewardDay;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    _feedCommentsByPostId = _loadFeedComments();
    streakDays = _preferences.getInt(keyStreak) ?? 0;
    await _syncTodayProgressWithCalendarDay();
    _loadCheckInHistory();
    await _migrateCheckInHistoryFromLastCompleteIfNeeded();

    final planSource = _preferences.getString(keyPlans);
    if (planSource != null && planSource.isNotEmpty) {
      weekPlans = PlanItem.decodeList(planSource);
    }
    final postSource = _preferences.getString(keyPosts);
    final List<DiscoverPost>? savedPosts =
        postSource != null && postSource.isNotEmpty ? DiscoverPost.decodeList(postSource) : null;

    List<DiscoverPost> manifestPosts = const [];
    try {
      manifestPosts = await CommunityManifest.loadDefaultPosts();
    } catch (_) {
      manifestPosts = const [];
    }

    if (manifestPosts.isNotEmpty) {
      discoverPosts = _mergeDiscoverWithSaved(manifestPosts, savedPosts);
    } else if (savedPosts != null && savedPosts.isNotEmpty) {
      discoverPosts = savedPosts;
    }
    discoverPosts = discoverPosts.map(_postWithSyncedCommentCount).toList();
    profileMetrics = profileMetrics.copyWith(
      currentWeight: _preferences.getDouble(keyWeight) ?? profileMetrics.currentWeight,
      monthlyWeightChange: _preferences.getDouble(keyWeightChange) ?? profileMetrics.monthlyWeightChange,
      proteinAchievementRate: _preferences.getInt(keyProteinRate) ?? profileMetrics.proteinAchievementRate,
    );
    profileNickname = _preferences.getString(keyProfileNickname) ?? AppConstants.projectName;
    profileSignature = _preferences.getString(keyProfileSignature) ?? '';
    profileAvatarRelativePath = _preferences.getString(keyProfileAvatarRelative);
    walletCoins = _preferences.getInt(keyWalletCoins) ?? 0;
    _lastWorkoutRewardDay = _preferences.getString(keyWalletLastWorkoutRewardDay);
    final hasClaimedNewUserGift = _preferences.getBool(keyWalletNewUserGiftClaimed) ?? false;
    if (!hasClaimedNewUserGift) {
      walletCoins += newUserGiftCoins;
      await _preferences.setBool(keyWalletNewUserGiftClaimed, true);
    }
    final processed = _preferences.getStringList(keyWalletProcessedPurchaseIds) ?? const [];
    _processedWalletPurchaseIds
      ..clear()
      ..addAll(processed);
    _loadBlockedDiscoverFilters();
    if (manifestPosts.isNotEmpty) {
      await _persist();
    }
    notifyListeners();
  }

  bool get isTodayWorkoutComplete => todayProgress >= 1.0;

  String get todayWorkoutTitle => TodayWorkoutDefaults.title;

  String get todayWorkoutSubtitle => TodayWorkoutDefaults.subtitle;

  String get todayWorkoutCalories => TodayWorkoutDefaults.calories;

  String get todayWorkoutLevel => TodayWorkoutDefaults.level;

  List<String> get checkInHistoryDescending {
    final unique = checkInDayKeys.toSet().toList();
    unique.sort((a, b) => b.compareTo(a));
    return unique;
  }

  Future<void> completeTodayWorkout() async {
    final today = _calendarDayKey(DateTime.now());
    final lastComplete = _preferences.getString(keyLastCompleteDay);
    if (lastComplete == today) {
      todayProgress = 1.0;
      _addCheckInDayIfNeeded(today);
      await _persist();
      notifyListeners();
      return;
    }

    todayProgress = 1.0;
    final previousStreak = streakDays;

    final lastDt = _parseCalendarDayKey(lastComplete);
    final todayDt = _dateOnly(DateTime.now());
    if (lastDt == null) {
      streakDays = 1;
    } else {
      final gapDays = todayDt.difference(lastDt).inDays;
      if (gapDays == 1) {
        streakDays += 1;
      } else if (gapDays >= 2) {
        streakDays = 1;
      }
    }

    _addCheckInDayIfNeeded(today);
    if (_lastWorkoutRewardDay != today) {
      walletCoins += workoutDailyRewardCoins;
      _lastWorkoutRewardDay = today;
    }
    if (previousStreak <= streakBonusThresholdDays && streakDays > streakBonusThresholdDays) {
      walletCoins += streakBonusCoins;
    }
    await _preferences.setString(keyLastCompleteDay, today);
    await _persist();
    notifyListeners();
  }

  void _addCheckInDayIfNeeded(String day) {
    if (checkInDayKeys.contains(day)) {
      return;
    }
    checkInDayKeys = [...checkInDayKeys, day];
  }

  void _loadCheckInHistory() {
    final raw = _preferences.getString(keyCheckInHistory);
    if (raw == null || raw.isEmpty) {
      checkInDayKeys = [];
      return;
    }
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      checkInDayKeys = list.map((e) => e as String).toList();
    } catch (_) {
      checkInDayKeys = [];
    }
  }

  Future<void> _migrateCheckInHistoryFromLastCompleteIfNeeded() async {
    if (checkInDayKeys.isNotEmpty) {
      return;
    }
    final last = _preferences.getString(keyLastCompleteDay);
    if (last == null || last.isEmpty) {
      return;
    }
    checkInDayKeys = [last];
    await _preferences.setString(keyCheckInHistory, jsonEncode(checkInDayKeys));
  }

  Future<void> _syncTodayProgressWithCalendarDay() async {
    final today = _calendarDayKey(DateTime.now());
    final savedDay = _preferences.getString(keyDailyProgressDay);
    if (savedDay != today) {
      todayProgress = 0;
      await _preferences.setString(keyDailyProgressDay, today);
      await _preferences.setDouble(keyDailyProgress, 0);
    } else {
      todayProgress = _preferences.getDouble(keyDailyProgress) ?? 0;
    }
  }

  static String _calendarDayKey(DateTime dt) {
    final d = _dateOnly(dt);
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  static DateTime _dateOnly(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  static DateTime? tryParseCalendarDayKey(String key) {
    return _parseCalendarDayKey(key);
  }

  static DateTime? _parseCalendarDayKey(String? key) {
    if (key == null || key.isEmpty) {
      return null;
    }
    try {
      final parts = key.split('-');
      if (parts.length != 3) {
        return null;
      }
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final d = int.parse(parts[2]);
      return DateTime(y, m, d);
    } catch (_) {
      return null;
    }
  }

  Future<void> cyclePlanStatus(int index) async {
    if (index < 0 || index >= weekPlans.length) {
      return;
    }
    final current = weekPlans[index];
    final nextStatus = switch (current.status) {
      PlanStatus.pending => PlanStatus.active,
      PlanStatus.active => PlanStatus.completed,
      PlanStatus.completed => PlanStatus.pending,
    };
    weekPlans[index] = current.copyWith(status: nextStatus);
    await _persist();
    notifyListeners();
  }

  Future<void> setPlanStatus(int index, PlanStatus status) async {
    if (index < 0 || index >= weekPlans.length) {
      return;
    }
    final current = weekPlans[index];
    weekPlans = [...weekPlans];
    weekPlans[index] = current.copyWith(status: status);
    await _persist();
    notifyListeners();
  }

  Future<void> movePlanItemUp(int index) async {
    if (index <= 0 || index >= weekPlans.length) {
      return;
    }
    final list = [...weekPlans];
    final item = list.removeAt(index);
    list.insert(index - 1, item);
    weekPlans = list;
    await _persist();
    notifyListeners();
  }

  Future<void> movePlanItemDown(int index) async {
    if (index < 0 || index >= weekPlans.length - 1) {
      return;
    }
    final list = [...weekPlans];
    final item = list.removeAt(index);
    list.insert(index + 1, item);
    weekPlans = list;
    await _persist();
    notifyListeners();
  }

  Future<void> addPlanItem({
    required String content,
    List<String> actions = const [],
  }) async {
    if (weekPlans.length >= planExtraLimitFreeCount) {
      final paid = await spendCoins(planExtraCostCoins, reason: 'plan_extra');
      if (!paid) {
        throw StateError(
          'Insufficient Coins. After $planExtraLimitFreeCount plans, each extra plan costs $planExtraCostCoins Coins.',
        );
      }
    }
    weekPlans = [
      ...weekPlans,
      PlanItem(
        content: content.trim(),
        status: PlanStatus.pending,
        actions: actions,
      ),
    ];
    await _persist();
    notifyListeners();
  }

  Future<void> updatePlanItem(int index, PlanItem item) async {
    if (index < 0 || index >= weekPlans.length) {
      return;
    }
    weekPlans = [...weekPlans];
    weekPlans[index] = item;
    await _persist();
    notifyListeners();
  }

  Future<void> toggleLike(String postId) async {
    final index = discoverPosts.indexWhere((item) => item.id == postId);
    if (index == -1) {
      return;
    }
    final current = discoverPosts[index];
    final liked = !current.liked;
    final likes = liked ? current.likes + 1 : (current.likes - 1).clamp(0, 999999);
    discoverPosts[index] = current.copyWith(liked: liked, likes: likes);
    await _persist();
    notifyListeners();
  }

  List<DiscoverPost> get visibleDiscoverPosts {
    return discoverPosts.where((post) {
      if (_blockedPostIds.contains(post.id)) {
        return false;
      }
      if (_blockedUserNames.contains(post.user)) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> blockDiscoverPost(String postId) async {
    _blockedPostIds.add(postId);
    await _persistBlockedDiscoverFilters();
    notifyListeners();
  }

  Future<void> blockDiscoverUser(String userNickname) async {
    _blockedUserNames.add(userNickname);
    await _persistBlockedDiscoverFilters();
    notifyListeners();
  }

  List<FeedComment> commentsForPost(String postId) {
    final list = _feedCommentsByPostId[postId];
    if (list == null || list.isEmpty) {
      return const [];
    }
    return List<FeedComment>.unmodifiable(list);
  }

  Future<void> addComment(String postId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final id = '${DateTime.now().millisecondsSinceEpoch}_${postId.hashCode.abs()}';
    final comment = FeedComment(
      id: id,
      postId: postId,
      authorName: profileNickname,
      body: trimmed,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
      isSelf: true,
    );
    final next = List<FeedComment>.from(_feedCommentsByPostId[postId] ?? []);
    next.add(comment);
    _feedCommentsByPostId[postId] = next;
    final index = discoverPosts.indexWhere((item) => item.id == postId);
    if (index != -1) {
      discoverPosts[index] = discoverPosts[index].copyWith(comments: next.length);
    }
    await _persist();
    notifyListeners();
  }

  Future<void> toggleBookmark(String postId) async {
    final index = discoverPosts.indexWhere((item) => item.id == postId);
    if (index == -1) {
      return;
    }
    final current = discoverPosts[index];
    discoverPosts[index] = current.copyWith(bookmarked: !current.bookmarked);
    await _persist();
    notifyListeners();
  }

  Future<void> saveUserProfile({
    required String nickname,
    required String signature,
    required String? avatarRelativePath,
  }) async {
    profileNickname = nickname.trim().isEmpty ? AppConstants.projectName : nickname.trim();
    profileSignature = signature.trim();
    final path = avatarRelativePath?.trim();
    profileAvatarRelativePath = (path == null || path.isEmpty) ? null : path;
    await _preferences.setString(keyProfileNickname, profileNickname);
    await _preferences.setString(keyProfileSignature, profileSignature);
    if (profileAvatarRelativePath == null || profileAvatarRelativePath!.isEmpty) {
      await _preferences.remove(keyProfileAvatarRelative);
    } else {
      await _preferences.setString(keyProfileAvatarRelative, profileAvatarRelativePath!);
    }
    notifyListeners();
  }

  Future<void> updateProfileMetrics({
    required double currentWeight,
    required double monthlyWeightChange,
    required int proteinAchievementRate,
  }) async {
    profileMetrics = profileMetrics.copyWith(
      currentWeight: currentWeight,
      monthlyWeightChange: monthlyWeightChange,
      proteinAchievementRate: proteinAchievementRate,
    );
    await _persist();
    notifyListeners();
  }

  Future<void> addWalletCoins(int coins) async {
    if (coins <= 0) {
      return;
    }
    walletCoins += coins;
    await _persist();
    notifyListeners();
  }

  Future<bool> spendCoins(int coins, {String? reason}) async {
    if (coins <= 0) {
      return true;
    }
    if (walletCoins < coins) {
      return false;
    }
    walletCoins -= coins;
    await _persist();
    notifyListeners();
    return true;
  }

  bool isWalletPurchaseProcessed(String purchaseId) {
    return _processedWalletPurchaseIds.contains(purchaseId);
  }

  Future<void> markWalletPurchaseProcessed(String purchaseId) async {
    if (purchaseId.isEmpty || _processedWalletPurchaseIds.contains(purchaseId)) {
      return;
    }
    _processedWalletPurchaseIds.add(purchaseId);
    await _preferences.setStringList(
      keyWalletProcessedPurchaseIds,
      _processedWalletPurchaseIds.toList()..sort(),
    );
  }

  Future<void> _persist() async {
    await _preferences.setInt(keyStreak, streakDays);
    await _preferences.setDouble(keyDailyProgress, todayProgress);
    await _preferences.setString(keyDailyProgressDay, _calendarDayKey(DateTime.now()));
    await _preferences.setString(keyCheckInHistory, jsonEncode(checkInDayKeys));
    await _preferences.setString(keyPlans, PlanItem.encodeList(weekPlans));
    await _preferences.setString(keyFeedComments, FeedComment.encodeStore(_feedCommentsByPostId));
    await _preferences.setString(keyPosts, DiscoverPost.encodeList(discoverPosts));
    await _preferences.setDouble(keyWeight, profileMetrics.currentWeight);
    await _preferences.setDouble(keyWeightChange, profileMetrics.monthlyWeightChange);
    await _preferences.setInt(keyProteinRate, profileMetrics.proteinAchievementRate);
    await _preferences.setString(keyProfileNickname, profileNickname);
    await _preferences.setString(keyProfileSignature, profileSignature);
    if (profileAvatarRelativePath != null && profileAvatarRelativePath!.isNotEmpty) {
      await _preferences.setString(keyProfileAvatarRelative, profileAvatarRelativePath!);
    } else {
      await _preferences.remove(keyProfileAvatarRelative);
    }
    await _preferences.setInt(keyWalletCoins, walletCoins);
    if (_lastWorkoutRewardDay != null && _lastWorkoutRewardDay!.isNotEmpty) {
      await _preferences.setString(keyWalletLastWorkoutRewardDay, _lastWorkoutRewardDay!);
    } else {
      await _preferences.remove(keyWalletLastWorkoutRewardDay);
    }
    await _preferences.setStringList(
      keyWalletProcessedPurchaseIds,
      _processedWalletPurchaseIds.toList()..sort(),
    );
  }

  List<DiscoverPost> _mergeDiscoverWithSaved(
    List<DiscoverPost> manifest,
    List<DiscoverPost>? saved,
  ) {
    if (saved == null || saved.isEmpty) {
      return manifest;
    }
    final byId = {for (final p in saved) p.id: p};
    return manifest
        .map((post) {
          final old = byId[post.id];
          if (old == null) {
            return post;
          }
          final baseLikes = post.likes;
          return post.copyWith(
            liked: old.liked,
            bookmarked: old.bookmarked,
            likes: old.liked ? baseLikes + 1 : baseLikes,
          );
        })
        .toList();
  }

  Map<String, List<FeedComment>> _loadFeedComments() {
    final raw = _preferences.getString(keyFeedComments);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    try {
      return FeedComment.decodeStore(raw);
    } catch (_) {
      return {};
    }
  }

  DiscoverPost _postWithSyncedCommentCount(DiscoverPost post) {
    final n = _feedCommentsByPostId[post.id]?.length ?? 0;
    return post.copyWith(comments: n);
  }

  void _loadBlockedDiscoverFilters() {
    _blockedPostIds.clear();
    _blockedUserNames.clear();
    final postsRaw = _preferences.getString(keyBlockedPostIds);
    if (postsRaw != null && postsRaw.isNotEmpty) {
      try {
        final list = jsonDecode(postsRaw) as List<dynamic>;
        _blockedPostIds.addAll(list.map((e) => e as String));
      } catch (_) {}
    }
    final usersRaw = _preferences.getString(keyBlockedUserNames);
    if (usersRaw != null && usersRaw.isNotEmpty) {
      try {
        final list = jsonDecode(usersRaw) as List<dynamic>;
        _blockedUserNames.addAll(list.map((e) => e as String));
      } catch (_) {}
    }
  }

  Future<void> _persistBlockedDiscoverFilters() async {
    await _preferences.setString(keyBlockedPostIds, jsonEncode(_blockedPostIds.toList()..sort()));
    await _preferences.setString(keyBlockedUserNames, jsonEncode(_blockedUserNames.toList()..sort()));
  }
}
