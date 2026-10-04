import 'dart:math';
import 'enums.dart';
import 'lesson.dart';
import 'question.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String category;
  final Difficulty difficulty;
  final Duration duration;
  final List<String> outcomes;
  final List<Lesson> lessons;
  final List<Question> questionBank;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.outcomes,
    required this.lessons,
    required this.questionBank,
  });

  int get quizQuestionCount => min(10, questionBank.length);

  /// 3-letter code used in certificate ID generation (e.g. FLT, PYT, WEB, SEC)
  String get code {
    if (id.contains('flutter')) return 'FLT';
    if (id.contains('python')) return 'PYT';
    if (id.contains('web')) return 'WEB';
    if (id.contains('cyber') || id.contains('sec')) return 'SEC';
    final alphanumeric = id.replaceAll(RegExp(r'[^a-zA-Z]'), '').toUpperCase();
    return alphanumeric.length >= 3 ? alphanumeric.substring(0, 3) : 'SKL';
  }
}
