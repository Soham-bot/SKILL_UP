import 'dart:math';
import '../models/course.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';

class QuizService {
  static const double passMark = 60.0;

  /// Pure Dart scoring engine using loop and conditional logic.
  /// Unanswered questions (or invalid indices) are counted as incorrect.
  /// Handles empty questions gracefully without division by zero.
  static QuizResult evaluate({
    required Course course,
    required List<Question> questions,
    required Map<int, int> answers, // questionIndex -> chosenOptionIndex
    required String learnerName,
    DateTime? timestamp,
  }) {
    int score = 0;

    // LOOP
    for (int i = 0; i < questions.length; i++) {
      final chosen = answers[i];
      // CONDITIONAL
      if (chosen != null && chosen == questions[i].correctIndex) {
        score++;
      }
    }

    // Zero-check division guard
    final percentage = questions.isEmpty ? 0.0 : (score / questions.length) * 100.0;
    // CONDITIONAL pass threshold
    final passed = percentage >= passMark;

    final now = timestamp ?? DateTime.now();
    final certId = QuizResult.generateCertificateId(course.code, now);

    return QuizResult(
      id: certId,
      courseId: course.id,
      courseTitle: course.title,
      learnerName: learnerName.trim().isEmpty ? 'Learner' : learnerName.trim(),
      score: score,
      totalQuestions: questions.length,
      percentage: double.parse(percentage.toStringAsFixed(1)),
      passed: passed,
      completedAt: now,
      selectedAnswers: Map<int, int>.unmodifiable(answers),
      questions: List<Question>.unmodifiable(questions),
    );
  }

  /// Selects questions for the assessment:
  /// - Exact count = min(10, course.questionBank.length)
  /// - Stratified: At least one question per lesson (if available)
  /// - No duplicates
  /// - Shuffles question order
  /// - Shuffles option order per question and tracks the new correctIndex
  static List<Question> selectQuestionsForQuiz(Course course, {Random? random}) {
    final rng = random ?? Random();
    final bank = List<Question>.from(course.questionBank);
    final targetCount = course.quizQuestionCount;

    if (bank.isEmpty) return const [];
    if (bank.length <= targetCount) {
      return _shuffleQuestionsAndOptions(bank, rng);
    }

    // Group questions by lessonId for stratification
    final Map<String, List<Question>> byLesson = {};
    for (final q in bank) {
      byLesson.putIfAbsent(q.lessonId, () => []).add(q);
    }

    final selected = <Question>[];
    final selectedIds = <String>{};

    // 1. Pick at least one question from each lesson
    final lessonKeys = byLesson.keys.toList();
    for (final lessonId in lessonKeys) {
      final lessonQuestions = byLesson[lessonId] ?? [];
      if (lessonQuestions.isNotEmpty) {
        final randomIndex = rng.nextInt(lessonQuestions.length);
        final picked = lessonQuestions[randomIndex];
        selected.add(picked);
        selectedIds.add(picked.id);
      }
    }

    // 2. Fill remaining slots from the remaining pool
    final remainingPool = bank.where((q) => !selectedIds.contains(q.id)).toList()..shuffle(rng);
    while (selected.length < targetCount && remainingPool.isNotEmpty) {
      selected.add(remainingPool.removeLast());
    }

    // 3. Shuffle question order & options
    return _shuffleQuestionsAndOptions(selected, rng);
  }

  static List<Question> _shuffleQuestionsAndOptions(List<Question> questions, Random rng) {
    final shuffledQuestions = List<Question>.from(questions)..shuffle(rng);

    return shuffledQuestions.map((q) {
      final originalCorrectOption = q.options[q.correctIndex];
      final shuffledOptions = List<String>.from(q.options)..shuffle(rng);
      final newCorrectIndex = shuffledOptions.indexOf(originalCorrectOption);

      return q.copyWith(
        options: shuffledOptions,
        correctIndex: newCorrectIndex,
      );
    }).toList();
  }
}
