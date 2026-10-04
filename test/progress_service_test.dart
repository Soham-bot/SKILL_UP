import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/data/course_repository.dart';
import 'package:skillup/models/enums.dart';
import 'package:skillup/models/learner_profile.dart';
import 'package:skillup/models/quiz_result.dart';
import 'package:skillup/services/progress_service.dart';
import 'package:skillup/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProgressService & StorageService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('corrupt prefs fallback safely without crashing', () async {
      SharedPreferences.setMockInitialValues({
        'skillup_best_result_flutter-fundamentals': '{invalid json corrupt}',
        'skillup_attempt_history': ['not json', '{bad}'],
        'skillup_theme_mode': 'nonexistent_mode',
      });

      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);

      // Verify no crashes occurred and safe defaults are used
      expect(progress.profile.name, isEmpty);
      expect(progress.getBestResult('flutter-fundamentals'), isNull);
      expect(storage.loadAttemptHistory(), isEmpty);
    });

    test('enrollment and lesson completion unlocks final assessment', () async {
      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);
      final course = CourseRepository.allCourses.first;

      expect(progress.isEnrolled(course.id), isFalse);
      expect(progress.isFinalAssessmentUnlocked(course.id), isFalse);

      await progress.enroll(course.id);
      expect(progress.isEnrolled(course.id), isTrue);
      expect(progress.getCourseStatus(course.id), CourseStatus.inProgress);

      // Mark first 4 lessons complete
      for (int i = 0; i < 4; i++) {
        await progress.markLessonCompleted(course.id, course.lessons[i].id);
      }
      expect(progress.completedLessonsCount(course.id), 4);
      expect(progress.isFinalAssessmentUnlocked(course.id), isFalse);

      // Mark 5th lesson complete
      await progress.markLessonCompleted(course.id, course.lessons[4].id);
      expect(progress.completedLessonsCount(course.id), 5);
      expect(progress.isFinalAssessmentUnlocked(course.id), isTrue);
    });

    test('retake after pass keeps the best score', () async {
      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);
      final course = CourseRepository.allCourses.first;

      final passingResult1 = QuizResult(
        id: 'SKL-FLT-2026-AAA1',
        courseId: course.id,
        courseTitle: course.title,
        learnerName: 'Alex',
        score: 9,
        totalQuestions: 10,
        percentage: 90.0,
        passed: true,
        completedAt: DateTime.now(),
        selectedAnswers: const {},
        questions: const [],
      );

      await progress.recordResult(passingResult1);
      expect(progress.getBestResult(course.id)?.score, 9);
      expect(progress.getCourseStatus(course.id), CourseStatus.completed);

      // Retake with lower passing score (e.g. 7/10)
      final passingResult2 = QuizResult(
        id: 'SKL-FLT-2026-AAA2',
        courseId: course.id,
        courseTitle: course.title,
        learnerName: 'Alex',
        score: 7,
        totalQuestions: 10,
        percentage: 70.0,
        passed: true,
        completedAt: DateTime.now(),
        selectedAnswers: const {},
        questions: const [],
      );

      await progress.recordResult(passingResult2);
      // Best score should remain 9
      expect(progress.getBestResult(course.id)?.score, 9);
      expect(progress.getCourseStatus(course.id), CourseStatus.completed);
    });

    test('LearnerProfile name validation rules', () {
      expect(LearnerProfile.validateName(null), isNotNull);
      expect(LearnerProfile.validateName(''), isNotNull);
      expect(LearnerProfile.validateName('   '), isNotNull);
      expect(LearnerProfile.validateName('A'), isNotNull); // < 2 chars
      expect(LearnerProfile.validateName('A' * 51), isNotNull); // > 50 chars
      expect(LearnerProfile.validateName('John123'), isNotNull); // digits not allowed
      expect(LearnerProfile.validateName('User@Name'), isNotNull); // @ not allowed

      expect(LearnerProfile.validateName('Ada Lovelace'), isNull);
      expect(LearnerProfile.validateName("O'Connor-Smith Jr."), isNull);
      expect(LearnerProfile.validateName('Soham Ahirrao'), isNull);
    });
  });
}
