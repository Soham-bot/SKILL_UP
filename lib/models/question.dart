class Question {
  final String id;
  final String moduleId;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String? hint; // Demonstrating Dart sound null safety
  final String? explanation; // Demonstrating Dart sound null safety

  const Question({
    required this.id,
    required this.moduleId,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    this.hint,
    this.explanation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleId': moduleId,
      'questionText': questionText,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'hint': hint,
      'explanation': explanation,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      questionText: json['questionText'] as String,
      options: (json['options'] as List<dynamic>).map((e) => e.toString()).toList(),
      correctOptionIndex: json['correctOptionIndex'] as int,
      hint: json['hint'] as String?,
      explanation: json['explanation'] as String?,
    );
  }
}
