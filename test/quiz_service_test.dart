import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:skillup/data/course_repository.dart';
import 'package:skillup/models/question.dart';
import 'package:skillup/models/quiz_result.dart';
import 'package:skillup/services/quiz_service.dart';

void main() {
  group('QuizService Unit Tests — Evaluation & Scoring', () {
    final sampleCourse = CourseRepository.allCourses.first;

    final testQuestions = List.generate(
      10,
      (i) => Question(
        id: 'q$i',
        lessonId: 'l${(i % 5) + 1}',
        prompt: 'Question $i prompt',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 1, // 'B' is correct
        hint: i.isEven ? 'Hint $i' : null,
        explanation: i.isOdd ? 'Explanation $i' : null,
      ),
    );

    test('evaluate with 0 correct produces score 0 and passed = false', () {
      final answers = {for (int i = 0; i < 10; i++) i: 0}; // all picked 'A', none correct
      final result = QuizService.evaluate(
        course: sampleCourse,
        questions: testQuestions,
        answers: answers,
        learnerName: 'Test Learner',
      );

      expect(result.score, 0);
      expect(result.percentage, 0.0);
      expect(result.passed, isFalse);
    });

    test('evaluate with 5 correct produces 50% and passed = false', () {
      final answers = <int, int>{};
      for (int i = 0; i < 5; i++) {
        answers[i] = 1; // Correct
      }
      for (int i = 5; i < 10; i++) {
        answers[i] = 0; // Wrong
      }

      final result = QuizService.evaluate(
        course: sampleCourse,
        questions: testQuestions,
        answers: answers,
        learnerName: 'Test Learner',
      );

      expect(result.score, 5);
      expect(result.percentage, 50.0);
      expect(result.passed, isFalse);
    });

    test('evaluate with 6 correct hits 60% boundary pass threshold', () {
      final answers = <int, int>{};
      for (int i = 0; i < 6; i++) {
        answers[i] = 1; // 6 Correct
      }
      for (int i = 6; i < 10; i++) {
        answers[i] = 0; // 4 Wrong
      }

      final result = QuizService.evaluate(
        course: sampleCourse,
        questions: testQuestions,
        answers: answers,
        learnerName: 'Boundary Learner',
      );

      expect(result.score, 6);
      expect(result.percentage, 60.0);
      expect(result.passed, isTrue);
    });

    test('evaluate with 10 correct produces 100% and passed = true', () {
      final answers = {for (int i = 0; i < 10; i++) i: 1}; // all correct

      final result = QuizService.evaluate(
        course: sampleCourse,
        questions: testQuestions,
        answers: answers,
        learnerName: 'Perfect Learner',
      );

      expect(result.score, 10);
      expect(result.percentage, 100.0);
      expect(result.passed, isTrue);
    });

    test('unanswered questions are safely counted as incorrect', () {
      final answers = {0: 1, 2: 1}; // only 2 questions answered, 8 skipped

      final result = QuizService.evaluate(
        course: sampleCourse,
        questions: testQuestions,
        answers: answers,
        learnerName: 'Partial Learner',
      );

      expect(result.score, 2);
      expect(result.percentage, 20.0);
      expect(result.passed, isFalse);
    });

    test('empty questions list does not divide by zero', () {
      final result = QuizService.evaluate(
        course: sampleCourse,
        questions: const [],
        answers: const {},
        learnerName: 'Empty Learner',
      );

      expect(result.score, 0);
      expect(result.percentage, 0.0);
      expect(result.passed, isFalse);
    });
  });

  group('QuizService Unit Tests — Question Selection & Stratification', () {
    test('selectQuestionsForQuiz returns exactly min(10, bank) without duplicates', () {
      for (final course in CourseRepository.allCourses) {
        final selected = QuizService.selectQuestionsForQuiz(course);
        expect(selected.length, min(10, course.questionBank.length));

        final ids = selected.map((q) => q.id).toSet();
        expect(ids.length, selected.length, reason: 'No duplicate questions should exist in ${course.id}');
      }
    });

    test('selectQuestionsForQuiz covers all 5 lessons across selected questions', () {
      for (final course in CourseRepository.allCourses) {
        final selected = QuizService.selectQuestionsForQuiz(course);
        final representedLessons = selected.map((q) => q.lessonId).toSet();

        for (final lesson in course.lessons) {
          expect(
            representedLessons.contains(lesson.id),
            isTrue,
            reason: 'Selected questions must represent lesson ${lesson.id} in ${course.id}',
          );
        }
      }
    });

    test('correctIndex remains valid after option shuffling', () {
      final course = CourseRepository.allCourses.first;
      final selected = QuizService.selectQuestionsForQuiz(course);

      for (final q in selected) {
        expect(q.correctIndex, greaterThanOrEqualTo(0));
        expect(q.correctIndex, lessThan(q.options.length));
        expect(q.options.length, 4);

        // Find original question in bank to ensure text matches
        final original = course.questionBank.firstWhere((item) => item.id == q.id);
        final originalAnswerText = original.options[original.correctIndex];
        final shuffledAnswerText = q.options[q.correctIndex];

        expect(
          shuffledAnswerText,
          originalAnswerText,
          reason: 'Correct index must point to the identical answer string after shuffling',
        );
      }
    });
  });

  group('Models & Serialization Tests', () {
    test('handles hint == null and explanation == null gracefully', () {
      const q = Question(
        id: 'test_null',
        lessonId: 'l1',
        prompt: 'Prompt',
        options: ['1', '2', '3', '4'],
        correctIndex: 0,
        hint: null,
        explanation: null,
      );

      final json = q.toJson();
      expect(json.containsKey('hint'), isFalse);
      expect(json.containsKey('explanation'), isFalse);

      final revived = Question.fromJson(json);
      expect(revived.hint, isNull);
      expect(revived.explanation, isNull);
    });

    test('QuizResult JSON round-trip preserves all fields accurately', () {
      final sampleCourse = CourseRepository.allCourses.first;
      final questions = sampleCourse.questionBank.take(10).toList();
      final original = QuizService.evaluate(
        course: sampleCourse,
        questions: questions,
        answers: {0: 1, 1: 2},
        learnerName: 'Ada Lovelace',
        timestamp: DateTime(2026, 10, 4, 12, 0, 0),
      );

      final json = original.toJson();
      final revived = QuizResult.fromJson(json);

      expect(revived.id, original.id);
      expect(revived.courseId, original.courseId);
      expect(revived.courseTitle, original.courseTitle);
      expect(revived.learnerName, original.learnerName);
      expect(revived.score, original.score);
      expect(revived.totalQuestions, original.totalQuestions);
      expect(revived.percentage, original.percentage);
      expect(revived.passed, original.passed);
      expect(revived.selectedAnswers, original.selectedAnswers);
      expect(revived.questions.length, original.questions.length);
    });

    test('certificate ID format regex matches SKL-<CODE3>-<YYYY>-<4 alphanumerics>', () {
      final regex = RegExp(r'^SKL-[A-Z]{3}-\d{4}-[A-Z0-9]{4}$');

      for (int i = 0; i < 20; i++) {
        final id = QuizResult.generateCertificateId('FLT', DateTime(2026, 1, 1));
        expect(regex.hasMatch(id), isTrue, reason: 'Generated ID $id should match expected regex');
      }
    });
  });
}
