import 'dart:convert';

class DiscoverPost {
  const DiscoverPost({
    required this.id,
    required this.user,
    required this.title,
    required this.content,
    required this.likes,
    required this.comments,
    required this.liked,
    required this.bookmarked,
    this.tags = const [],
    this.quote = '',
    this.avatarAsset,
    this.videoAsset,
    this.imageAssets = const [],
    this.weeklyWorkouts = 0,
    this.dailyStepAvg = 0,
    this.dailyCalorieTarget = 0,
    this.hydrationTargetMl = 0,
    this.sleepHoursTarget = 0,
    this.restingHeartRateBpm = 0,
    this.nutritionTip = '',
  });

  final String id;
  final String user;
  final String title;
  final String content;
  final int likes;
  final int comments;
  final bool liked;
  final bool bookmarked;
  final List<String> tags;
  final String quote;
  final String? avatarAsset;
  final String? videoAsset;
  final List<String> imageAssets;
  final int weeklyWorkouts;
  final int dailyStepAvg;
  final int dailyCalorieTarget;
  final int hydrationTargetMl;
  final double sleepHoursTarget;
  final int restingHeartRateBpm;
  final String nutritionTip;

  DiscoverPost copyWith({
    String? id,
    String? user,
    String? title,
    String? content,
    int? likes,
    int? comments,
    bool? liked,
    bool? bookmarked,
    List<String>? tags,
    String? quote,
    String? avatarAsset,
    String? videoAsset,
    List<String>? imageAssets,
    int? weeklyWorkouts,
    int? dailyStepAvg,
    int? dailyCalorieTarget,
    int? hydrationTargetMl,
    double? sleepHoursTarget,
    int? restingHeartRateBpm,
    String? nutritionTip,
  }) {
    return DiscoverPost(
      id: id ?? this.id,
      user: user ?? this.user,
      title: title ?? this.title,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      liked: liked ?? this.liked,
      bookmarked: bookmarked ?? this.bookmarked,
      tags: tags ?? this.tags,
      quote: quote ?? this.quote,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      videoAsset: videoAsset ?? this.videoAsset,
      imageAssets: imageAssets ?? this.imageAssets,
      weeklyWorkouts: weeklyWorkouts ?? this.weeklyWorkouts,
      dailyStepAvg: dailyStepAvg ?? this.dailyStepAvg,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      hydrationTargetMl: hydrationTargetMl ?? this.hydrationTargetMl,
      sleepHoursTarget: sleepHoursTarget ?? this.sleepHoursTarget,
      restingHeartRateBpm: restingHeartRateBpm ?? this.restingHeartRateBpm,
      nutritionTip: nutritionTip ?? this.nutritionTip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'title': title,
      'content': content,
      'likes': likes,
      'comments': comments,
      'liked': liked,
      'bookmarked': bookmarked,
      'tags': tags,
      'quote': quote,
      'avatarAsset': avatarAsset,
      'videoAsset': videoAsset,
      'imageAssets': imageAssets,
      'weeklyWorkouts': weeklyWorkouts,
      'dailyStepAvg': dailyStepAvg,
      'dailyCalorieTarget': dailyCalorieTarget,
      'hydrationTargetMl': hydrationTargetMl,
      'sleepHoursTarget': sleepHoursTarget,
      'restingHeartRateBpm': restingHeartRateBpm,
      'nutritionTip': nutritionTip,
    };
  }

  factory DiscoverPost.fromMap(Map<String, dynamic> map) {
    final tagsRaw = map['tags'] as List<dynamic>?;
    final imagesRaw = map['imageAssets'] as List<dynamic>?;
    return DiscoverPost(
      id: map['id'] as String? ?? '',
      user: map['user'] as String? ?? '',
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      likes: (map['likes'] as num?)?.toInt() ?? 0,
      comments: (map['comments'] as num?)?.toInt() ?? 0,
      liked: map['liked'] as bool? ?? false,
      bookmarked: map['bookmarked'] as bool? ?? false,
      tags: tagsRaw?.map((e) => e as String).toList() ?? const [],
      quote: map['quote'] as String? ?? '',
      avatarAsset: map['avatarAsset'] as String?,
      videoAsset: map['videoAsset'] as String?,
      imageAssets: imagesRaw?.map((e) => e as String).toList() ?? const [],
      weeklyWorkouts: (map['weeklyWorkouts'] as num?)?.toInt() ?? 0,
      dailyStepAvg: (map['dailyStepAvg'] as num?)?.toInt() ?? 0,
      dailyCalorieTarget: (map['dailyCalorieTarget'] as num?)?.toInt() ?? 0,
      hydrationTargetMl: (map['hydrationTargetMl'] as num?)?.toInt() ?? 0,
      sleepHoursTarget: (map['sleepHoursTarget'] as num?)?.toDouble() ?? 0,
      restingHeartRateBpm: (map['restingHeartRateBpm'] as num?)?.toInt() ?? 0,
      nutritionTip: map['nutritionTip'] as String? ?? '',
    );
  }

  factory DiscoverPost.fromManifestUser(Map<String, dynamic> map) {
    final tags = (map['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[];
    final images = (map['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[];
    return DiscoverPost(
      id: map['id'] as String? ?? '',
      user: map['nickname'] as String? ?? '',
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      likes: (map['likes'] as num?)?.toInt() ?? 0,
      comments: 0,
      liked: false,
      bookmarked: false,
      tags: tags,
      quote: map['quote'] as String? ?? '',
      avatarAsset: map['avatar'] as String?,
      videoAsset: map['video'] as String?,
      imageAssets: images,
      weeklyWorkouts: (map['weeklyWorkouts'] as num?)?.toInt() ?? 0,
      dailyStepAvg: (map['dailyStepAvg'] as num?)?.toInt() ?? 0,
      dailyCalorieTarget: (map['dailyCalorieTarget'] as num?)?.toInt() ?? 0,
      hydrationTargetMl: (map['hydrationTargetMl'] as num?)?.toInt() ?? 0,
      sleepHoursTarget: (map['sleepHoursTarget'] as num?)?.toDouble() ?? 0,
      restingHeartRateBpm: (map['restingHeartRateBpm'] as num?)?.toInt() ?? 0,
      nutritionTip: map['nutritionTip'] as String? ?? '',
    );
  }

  static String encodeList(List<DiscoverPost> list) {
    final mapped = list.map((item) => item.toMap()).toList();
    return jsonEncode(mapped);
  }

  static List<DiscoverPost> decodeList(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded
        .map((item) => DiscoverPost.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
