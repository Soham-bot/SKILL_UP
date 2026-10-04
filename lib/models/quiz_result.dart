import 'dart:math';
import 'question.dart';

class QuizResult {
  final String id; // Format: SKL-<COURSE3>-<YYYY>-<4 random alphanumerics>
  final String courseId;
  final String courseTitle;
  final String learnerName;
  final int score;
  final int totalQuestions;
  final double percentage;
  final bool passed;
  final DateTime completedAt;
  final Map<int, int> selectedAnswers; // questionIndex -> chosenOptionIndex
  final List<Question> questions;

  const QuizResult({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.learnerName,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.passed,
    required this.completedAt,
    required this.selectedAnswers,
    required this.questions,
  });

  static String generateCertificateId(String courseCode, [DateTime? date]) {
    final now = date ?? DateTime.now();
    final year = now.year.toString();
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Avoid ambiguous 0, O, 1, I
    final random = Random();
    final suffix = List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
    final code = courseCode.toUpperCase().padRight(3, 'X').substring(0, 3);
    return 'SKL-$code-$year-$suffix';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'courseTitle': courseTitle,
    'learnerName': learnerName,
    'score': score,
    'totalQuestions': totalQuestions,
    'percentage': percentage,
    'passed': passed,
    'completedAt': completedAt.toIso8601String(),
    'selectedAnswers': selectedAnswers.map((k, v) => MapEntry(k.toString(), v)),
    'questions': questions.map((q) => q.toJson()).toList(),
  };

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['selectedAnswers'] as Map<String, dynamic>? ?? {};
    final answers = <int, int>{};
    rawAnswers.forEach((k, v) {
      final keyInt = int.tryParse(k);
      final valInt = v is int ? v : int.tryParse(v.toString());
      if (keyInt != null && valInt != null) {
        answers[keyInt] = valInt;
      }
    });

    final rawQuestions = json['questions'] as List<dynamic>? ?? [];
    final questions = rawQuestions
        .whereType<Map<String, dynamic>>()
        .map((q) => Question.fromJson(q))
        .toList();

    return QuizResult(
      id: json['id'] as String? ?? 'SKL-GEN-${DateTime.now().year}-0000',
      courseId: json['courseId'] as String? ?? '',
      courseTitle: json['courseTitle'] as String? ?? '',
      learnerName: json['learnerName'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? questions.length,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      passed: json['passed'] as bool? ?? false,
      completedAt: DateTime.tryParse(json['completedAt'] as String? ?? '') ?? DateTime.now(),
      selectedAnswers: answers,
      questions: questions,
    );
  }
}
