class ModuleSection {
  final String title;
  final String body;
  final String? codeSnippet;
  final List<String> bulletPoints;
  final String? tip;

  const ModuleSection({
    required this.title,
    required this.body,
    this.codeSnippet,
    this.bulletPoints = const [],
    this.tip,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'codeSnippet': codeSnippet,
      'bulletPoints': bulletPoints,
      'tip': tip,
    };
  }

  factory ModuleSection.fromJson(Map<String, dynamic> json) {
    return ModuleSection(
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      codeSnippet: json['codeSnippet'] as String?,
      bulletPoints: (json['bulletPoints'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      tip: json['tip'] as String?,
    );
  }
}

class LearningModule {
  final String id;
  final int orderIndex; // 1 to 5
  final String title;
  final String estimatedMinutes;
  final String summary;
  final List<ModuleSection> sections;
  final String keyTakeaway;
  bool isCompleted;

  LearningModule({
    required this.id,
    required this.orderIndex,
    required this.title,
    required this.estimatedMinutes,
    required this.summary,
    required this.sections,
    required this.keyTakeaway,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderIndex': orderIndex,
      'title': title,
      'estimatedMinutes': estimatedMinutes,
      'summary': summary,
      'sections': sections.map((s) => s.toJson()).toList(),
      'keyTakeaway': keyTakeaway,
      'isCompleted': isCompleted,
    };
  }

  factory LearningModule.fromJson(Map<String, dynamic> json) {
    return LearningModule(
      id: json['id'] as String,
      orderIndex: json['orderIndex'] as int,
      title: json['title'] as String,
      estimatedMinutes: json['estimatedMinutes'] as String? ?? '10 min',
      summary: json['summary'] as String? ?? '',
      sections: (json['sections'] as List<dynamic>?)
              ?.map((s) => ModuleSection.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      keyTakeaway: json['keyTakeaway'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
