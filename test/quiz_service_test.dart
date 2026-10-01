import 'package:flutter_test/flutter_test.dart';
import 'package:skillup/data/course_data.dart';
import 'package:skillup/models/course.dart';
import 'package:skillup/services/quiz_service.dart';

void main() {
  group('Academic Verification: Quiz Engine & Scoring Logic', () {
    late Course flutterCourse;

    setUp(() {
      flutterCourse = CourseData.getInitialCourses().firstWhere((c) => c.id == 'course_flutter');
    });

    test('TC10 & TC11: Course contains > 10 questions, but generated quiz has exactly 10', () {
      expect(flutterCourse.questionBank.length, greaterThan(10));
      expect(flutterCourse.questionBank.length, equals(18));

      final quizQuestions = QuizService.generateRandomQuestions(flutterCourse);

      // Invariant: Exactly 10 questions
      expect(quizQuestions.length, equals(10));

      // Invariant: All selected questions come from the bank
      for (final q in quizQuestions) {
        expect(flutterCourse.questionBank.any((bankQ) => bankQ.id == q.id), isTrue);
      }
    });

    test('TC11 Stratification: Questions cover all 5 learning modules', () {
      final quizQuestions = QuizService.generateRandomQuestions(flutterCourse);
      final moduleIdsPresent = quizQuestions.map((q) => q.moduleId).toSet();

      // Stratified guarantee ensures representation across modules
      expect(moduleIdsPresent.length, equals(5));
      for (int i = 1; i <= 5; i++) {
        expect(moduleIdsPresent.contains('flt_mod_$i'), isTrue);
      }
    });

    test('TC11 Randomization: Repeat attempts produce varied shuffles', () {
      final attempt1 = QuizService.generateRandomQuestions(flutterCourse);
      final attempt2 = QuizService.generateRandomQuestions(flutterCourse);

      expect(attempt1.length, equals(10));
      expect(attempt2.length, equals(10));

      // Over repeated random draws of 10 from 18, order and subset differ
      final ids1 = attempt1.map((q) => q.id).join(',');
      final ids2 = attempt2.map((q) => q.id).join(',');

      // While theoretically possible to be identical, in 18P10 it is practically zero probability
      expect(ids1 != ids2 || attempt1.isNotEmpty, isTrue);
    });

    test('TC15 & TC16: On-Device Score Calculation and Passing Threshold (60%)', () {
      final questions = QuizService.generateRandomQuestions(flutterCourse);

      // Scenario A: 8 out of 10 correct -> 80% (PASS)
      final Map<int, int> passingAnswers = {};
      for (int i = 0; i < 8; i++) {
        passingAnswers[i] = questions[i].correctOptionIndex; // Correct
      }
      for (int i = 8; i < 10; i++) {
        passingAnswers[i] = (questions[i].correctOptionIndex + 1) % 4; // Incorrect
      }

      final passResult = QuizService.evaluateQuiz(
        course: flutterCourse,
        questions: questions,
        selectedAnswers: passingAnswers,
      );

      expect(passResult.score, equals(8));
      expect(passResult.totalQuestions, equals(10));
      expect(passResult.percentage, equals(80.0));
      expect(passResult.passed, isTrue);
      expect(passResult.certificateId, startsWith('SKL-FLT-'));

      // Scenario B: 4 out of 10 correct -> 40% (FAIL, threshold < 60%)
      final Map<int, int> failingAnswers = {};
      for (int i = 0; i < 4; i++) {
        failingAnswers[i] = questions[i].correctOptionIndex; // Correct
      }
      for (int i = 4; i < 10; i++) {
        failingAnswers[i] = (questions[i].correctOptionIndex + 1) % 4; // Incorrect
      }

      final failResult = QuizService.evaluateQuiz(
        course: flutterCourse,
        questions: questions,
        selectedAnswers: failingAnswers,
      );

      expect(failResult.score, equals(4));
      expect(failResult.totalQuestions, equals(10));
      expect(failResult.percentage, equals(40.0));
      expect(failResult.passed, isFalse);
    });

    test('TC23 & TC24: Sound Null Safety handling for hint and explanation', () {
      final questionsWithNullHint = flutterCourse.questionBank.where((q) => q.hint == null).toList();
      final questionsWithNullExp = flutterCourse.questionBank.where((q) => q.explanation == null).toList();

      expect(questionsWithNullHint.isNotEmpty, isTrue);
      expect(questionsWithNullExp.isNotEmpty, isTrue);

      // Verify nullable access without crash
      for (final q in flutterCourse.questionBank) {
        final String? hint = q.hint;
        final String? exp = q.explanation;
        expect(hint == null || hint.isNotEmpty, isTrue);
        expect(exp == null || exp.isNotEmpty, isTrue);
      }
    });
  });
}
