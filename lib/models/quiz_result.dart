class QuizResult {
  final String courseId;
  final String courseTitle;
  final int score;
  final int totalQuestions;
  final double percentage;
  final bool passed;
  final DateTime attemptedAt;
  final String certificateId;

  QuizResult({
    required this.courseId,
    required this.courseTitle,
    required this.score,
    this.totalQuestions = 10,
    required this.percentage,
    required this.passed,
    DateTime? attemptedAt,
    required this.certificateId,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'score': score,
      'totalQuestions': totalQuestions,
      'percentage': percentage,
      'passed': passed,
      'attemptedAt': attemptedAt.toIso8601String(),
      'certificateId': certificateId,
    };
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      courseId: json['courseId'] as String,
      courseTitle: json['courseTitle'] as String,
      score: (json['score'] as num).toInt(),
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 10,
      percentage: (json['percentage'] as num).toDouble(),
      passed: json['passed'] as bool,
      attemptedAt: DateTime.tryParse(json['attemptedAt'] as String) ?? DateTime.now(),
      certificateId: json['certificateId'] as String,
    );
  }
}
