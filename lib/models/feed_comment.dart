import 'dart:convert';

class FeedComment {
  const FeedComment({
    required this.id,
    required this.postId,
    required this.authorName,
    required this.body,
    required this.createdAtMillis,
    this.isSelf = false,
  });

  final String id;
  final String postId;
  final String authorName;
  final String body;
  final int createdAtMillis;
  final bool isSelf;

  bool get isOwnComment => isSelf || authorName == 'Me';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'authorName': authorName,
      'body': body,
      'createdAtMillis': createdAtMillis,
      'isSelf': isSelf,
    };
  }

  factory FeedComment.fromMap(Map<String, dynamic> map) {
    final name = map['authorName'] as String? ?? '';
    final selfFlag = map['isSelf'] as bool? ?? (name == 'Me');
    return FeedComment(
      id: map['id'] as String? ?? '',
      postId: map['postId'] as String? ?? '',
      authorName: name,
      body: map['body'] as String? ?? '',
      createdAtMillis: (map['createdAtMillis'] as num?)?.toInt() ?? 0,
      isSelf: selfFlag,
    );
  }

  static String encodeStore(Map<String, List<FeedComment>> byPost) {
    final out = <String, dynamic>{};
    byPost.forEach((key, list) {
      out[key] = list.map((c) => c.toMap()).toList();
    });
    return jsonEncode(out);
  }

  static Map<String, List<FeedComment>> decodeStore(String source) {
    final decoded = jsonDecode(source) as Map<String, dynamic>;
    final result = <String, List<FeedComment>>{};
    decoded.forEach((key, value) {
      final list = value as List<dynamic>;
      result[key] = list
          .map((item) => FeedComment.fromMap(item as Map<String, dynamic>))
          .toList();
    });
    return result;
  }
}
