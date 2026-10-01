import '../models/course.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../utils/certificate_utils.dart';

class QuizService {
  // CRITICAL ACADEMIC CONSTANT: Pass Mark is explicitly 60%
  static const double passPercentage = 60.0;
  static const int totalQuizQuestions = 10;

  /// Stratified Random Question Selection:
  /// Guarantees that the 10 selected questions are drawn across all 5 learning modules
  /// rather than clustering in a single module.
  static List<Question> generateRandomQuestions(Course course) {
    if (course.questionBank.length <= totalQuizQuestions) {
      final list = List<Question>.from(course.questionBank)..shuffle();
      return list;
    }

    // 1. Group question bank by module ID
    final Map<String, List<Question>> moduleBuckets = {};
    for (final q in course.questionBank) {
      moduleBuckets.putIfAbsent(q.moduleId, () => []).add(q);
    }

    final List<Question> selected = [];

    // 2. Stratified guarantee: Take at least 1-2 questions from each module bucket
    for (final entry in moduleBuckets.entries) {
      final shuffledModuleQuestions = List<Question>.from(entry.value)..shuffle();
      if (shuffledModuleQuestions.isNotEmpty) {
        selected.add(shuffledModuleQuestions.removeLast());
      }
    }

    // 3. Pool remaining questions, shuffle, and fill up to exactly 10 questions
    final List<Question> remainingPool = [];
    for (final q in course.questionBank) {
      if (!selected.contains(q)) {
        remainingPool.add(q);
      }
    }
    remainingPool.shuffle();

    while (selected.length < totalQuizQuestions && remainingPool.isNotEmpty) {
      selected.add(remainingPool.removeLast());
    }

    // 4. Final shuffle so module order is randomized for the test taker
    selected.shuffle();
    return selected;
  }

  /// On-Device Score Calculation:
  /// Pure Dart logic using list iteration, equality comparison, and percentage calculation.
  /// Zero server or external API dependency.
  static QuizResult evaluateQuiz({
    required Course course,
    required List<Question> questions,
    required Map<int, int> selectedAnswers, // questionIndex -> selectedOptionIndex
  }) {
    int score = 0;

    // Academic loop for score tallying
    for (int i = 0; i < questions.length; i++) {
      final selectedOption = selectedAnswers[i];
      final correctOption = questions[i].correctOptionIndex;

      if (selectedOption != null && selectedOption == correctOption) {
        score++;
      }
    }

    final double percentage = (score / questions.length) * 100.0;
    final bool passed = percentage >= passPercentage;
    final String certificateId = CertificateUtils.generateCertificateId(course.id);

    return QuizResult(
      courseId: course.id,
      courseTitle: course.title,
      score: score,
      totalQuestions: questions.length,
      percentage: double.parse(percentage.toStringAsFixed(1)),
      passed: passed,
      attemptedAt: DateTime.now(),
      certificateId: certificateId,
    );
  }
}
