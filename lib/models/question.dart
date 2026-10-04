class Question {
  final String id;
  final String lessonId;
  final String prompt;
  final List<String> options; // exactly 4
  final int correctIndex;
  final String? hint; // optional
  final String? explanation; // optional

  const Question({
    required this.id,
    required this.lessonId,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.hint,
    this.explanation,
  });

  Question copyWith({
    String? id,
    String? lessonId,
    String? prompt,
    List<String>? options,
    int? correctIndex,
    String? hint,
    String? explanation,
  }) {
    return Question(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      prompt: prompt ?? this.prompt,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      hint: hint ?? this.hint,
      explanation: explanation ?? this.explanation,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lessonId': lessonId,
    'prompt': prompt,
    'options': options,
    'correctIndex': correctIndex,
    if (hint != null) 'hint': hint,
    if (explanation != null) 'explanation': explanation,
  };

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String? ?? '',
      lessonId: json['lessonId'] as String? ?? '',
      prompt: json['prompt'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      correctIndex: json['correctIndex'] as int? ?? 0,
      hint: json['hint'] as String?,
      explanation: json['explanation'] as String?,
    );
  }
}
