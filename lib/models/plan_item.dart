import 'dart:convert';

enum PlanStatus { completed, active, pending }

class PlanItem {
  const PlanItem({
    required this.content,
    required this.status,
    this.actions = const [],
    this.backgroundRelativePath,
  });

  final String content;
  final PlanStatus status;
  final List<String> actions;

  /// Relative path under app documents (e.g. `plan_covers/xxx.jpg`); when `null`, use rotating built-in covers.
  final String? backgroundRelativePath;

  PlanItem copyWith({
    String? content,
    PlanStatus? status,
    List<String>? actions,
    String? backgroundRelativePath,
    bool clearBackgroundRelativePath = false,
  }) {
    return PlanItem(
      content: content ?? this.content,
      status: status ?? this.status,
      actions: actions ?? this.actions,
      backgroundRelativePath: clearBackgroundRelativePath
          ? null
          : (backgroundRelativePath ?? this.backgroundRelativePath),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'status': status.name,
      'actions': actions,
      if (backgroundRelativePath != null) 'backgroundRelativePath': backgroundRelativePath,
    };
  }

  factory PlanItem.fromMap(Map<String, dynamic> map) {
    final statusName = map['status'] as String? ?? PlanStatus.pending.name;
    final status = PlanStatus.values.firstWhere(
      (item) => item.name == statusName,
      orElse: () => PlanStatus.pending,
    );
    final actionsRaw = map['actions'];
    List<String> actionsList = [];
    if (actionsRaw is List) {
      actionsList = actionsRaw.map((e) => e.toString()).toList();
    }
    final bg = map['backgroundRelativePath'];
    return PlanItem(
      content: map['content'] as String? ?? '',
      status: status,
      actions: actionsList,
      backgroundRelativePath: bg is String && bg.isNotEmpty ? bg : null,
    );
  }

  static String encodeList(List<PlanItem> list) {
    final mapped = list.map((item) => item.toMap()).toList();
    return jsonEncode(mapped);
  }

  static List<PlanItem> decodeList(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded
        .map((item) => PlanItem.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
