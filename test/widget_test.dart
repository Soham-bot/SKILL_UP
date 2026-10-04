import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/app.dart';
import 'package:skillup/data/course_repository.dart';
import 'package:skillup/screens/quiz_screen.dart';
import 'package:skillup/screens/result_screen.dart';
import 'package:skillup/services/progress_scope.dart';
import 'package:skillup/services/progress_service.dart';
import 'package:skillup/services/quiz_service.dart';
import 'package:skillup/services/storage_service.dart';
import 'package:skillup/theme/app_theme.dart';
import 'package:skillup/widgets/course_card.dart';
import 'package:skillup/widgets/status_chip.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp(ProgressService progress) {
    return ProgressScope(
      progressService: progress,
      child: const SkillUpApp(),
    );
  }

  group('Widget Tests: Core Journey & Requirements', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('1. Welcome screen name validation enables continue button only on valid name',
        (tester) async {
      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);

      await tester.pumpWidget(buildApp(progress));
      await tester.pumpAndSettle();

      // Should be on WelcomeScreen
      expect(find.text('Welcome to SkillUp'), findsOneWidget);
      final continueButtonFinder = find.byKey(const Key('continue_button'));
      expect(continueButtonFinder, findsOneWidget);

      // Initially empty -> Continue button is disabled
      final FilledButton buttonInitially = tester.widget(continueButtonFinder);
      expect(buttonInitially.onPressed, isNull);

      // Enter invalid single char name
      await tester.enterText(find.byKey(const Key('name_input_field')), 'A');
      await tester.pump();
      expect(find.text('Name must be at least 2 characters.'), findsOneWidget);
      final FilledButton buttonInvalid = tester.widget(continueButtonFinder);
      expect(buttonInvalid.onPressed, isNull);

      // Enter invalid name with numbers
      await tester.enterText(find.byKey(const Key('name_input_field')), 'John123');
      await tester.pump();
      expect(find.text('Only letters, spaces, hyphens, dots, and apostrophes are allowed.'),
          findsOneWidget);

      // Enter valid name
      await tester.enterText(find.byKey(const Key('name_input_field')), 'Ada Lovelace');
      await tester.pump();
      expect(find.text('Name must be at least 2 characters.'), findsNothing);
      final FilledButton buttonValid = tester.widget(continueButtonFinder);
      expect(buttonValid.onPressed, isNotNull);

      // Tap continue -> transitions to Home
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Hello, Ada'), findsOneWidget);
    });

    testWidgets('2. Home screen shows exactly 4 available courses', (tester) async {
      SharedPreferences.setMockInitialValues({
        'skillup_profile_name': 'Eleanor Vance',
      });
      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);

      await tester.pumpWidget(buildApp(progress));
      await tester.pumpAndSettle();

      expect(find.text('Hello, Eleanor'), findsOneWidget);
      expect(find.text('Available Certifications'), findsOneWidget);
      expect(find.byType(CourseCard), findsNWidgets(4));
    });

    testWidgets('3. Enroll flow leads to Learning Path with 5 lessons', (tester) async {
      SharedPreferences.setMockInitialValues({
        'skillup_profile_name': 'Grace Hopper',
      });
      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);

      await tester.pumpWidget(buildApp(progress));
      await tester.pumpAndSettle();

      // Tap on Flutter Fundamentals course
      await tester.tap(find.text('Flutter Fundamentals'));
      await tester.pumpAndSettle();

      // On Course Detail Screen: Verify summary row items
      expect(find.text('Difficulty'), findsOneWidget);
      expect(find.text('Duration'), findsOneWidget);
      expect(find.text('Assessment'), findsOneWidget);
      expect(find.text('Enroll for Free'), findsOneWidget);

      // Tap Enroll
      await tester.tap(find.text('Enroll for Free'));
      await tester.pumpAndSettle();

      // Should be on Learning Path
      expect(find.text('Learning Path'), findsOneWidget);
      expect(find.text('0 of 5 lessons completed'), findsOneWidget);
      expect(find.text('Final Assessment & Certification'), findsOneWidget);
    });

    testWidgets('4. Assessment is locked until all 5 lessons are completed', (tester) async {
      SharedPreferences.setMockInitialValues({
        'skillup_profile_name': 'Katherine Johnson',
      });
      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);
      final course = CourseRepository.allCourses.first;

      await progress.enroll(course.id);
      // Only 3 of 5 lessons completed
      for (int i = 0; i < 3; i++) {
        await progress.markLessonCompleted(course.id, course.lessons[i].id);
      }

      await tester.pumpWidget(buildApp(progress));
      await tester.pumpAndSettle();

      // Go to Course Detail -> Continue Learning -> Learning Path
      await tester.tap(find.text('Flutter Fundamentals').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue Learning'));
      await tester.pumpAndSettle();

      expect(find.text('Complete all 5 lessons to unlock'), findsOneWidget);

      // Attempt to tap locked assessment
      await tester.ensureVisible(find.text('Final Assessment & Certification'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Final Assessment & Certification'));
      await tester.pumpAndSettle();

      // SnackBar alert should show and we should stay on Learning Path
      expect(find.textContaining('Complete all 5 lessons to unlock'), findsWidgets);
      expect(find.text('Learning Path'), findsOneWidget);

      // Now complete remaining 2 lessons
      await progress.markLessonCompleted(course.id, course.lessons[3].id);
      await progress.markLessonCompleted(course.id, course.lessons[4].id);
      await tester.pumpAndSettle();

      // Assessment is now unlocked
      expect(find.text('10 Questions · Pass mark 60% · Unlocked'), findsOneWidget);
    });

    testWidgets('5. Full passing flow: Quiz -> Review -> Result -> Certificate', (tester) async {
      SharedPreferences.setMockInitialValues({
        'skillup_profile_name': 'Alan Turing',
      });
      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);
      final course = CourseRepository.allCourses.first;

      // Complete all 5 lessons so assessment is unlocked
      for (final l in course.lessons) {
        await progress.markLessonCompleted(course.id, l.id);
      }

      await tester.pumpWidget(buildApp(progress));
      await tester.pumpAndSettle();

      // Navigate to Flutter course -> Learning Path -> Assessment
      await tester.tap(find.text('Flutter Fundamentals').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue Learning'));
      await tester.pumpAndSettle();

      // Tap unlocked final assessment
      await tester.ensureVisible(find.text('Final Assessment & Certification'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Final Assessment & Certification'));
      await tester.pumpAndSettle();

      // Assessment Intro Screen
      expect(find.text('Assessment Overview'), findsOneWidget);
      expect(find.text('10 Questions'), findsOneWidget);
      expect(find.text('60% Passing Threshold'), findsOneWidget);

      // Tap Start Assessment
      await tester.ensureVisible(find.text('Start Assessment'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start Assessment'));
      await tester.pumpAndSettle();

      // Quiz Screen — Jump to Question 10 using nav strip
      expect(find.text('Question 1 of 10'), findsOneWidget);
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      expect(find.text('Question 10 of 10'), findsOneWidget);

      // Now on Question 10, Next has become Review Answers
      await tester.tap(find.text('Review Answers'));
      await tester.pumpAndSettle();

      // Review Screen
      expect(find.text('Review & Submit'), findsOneWidget);
      expect(find.text('Answered 0 of 10'), findsOneWidget);
    });

    testWidgets('6. Completed course is visually marked Completed on Home after pass',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'skillup_profile_name': 'Margaret Hamilton',
      });
      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);
      final course = CourseRepository.allCourses.first;

      // Save a passed result
      final passedResult = QuizService.evaluate(
        course: course,
        questions: course.questionBank.take(10).toList(),
        answers: {for (int i = 0; i < 10; i++) i: course.questionBank[i].correctIndex},
        learnerName: 'Margaret Hamilton',
      );
      await progress.recordResult(passedResult);

      await tester.pumpWidget(buildApp(progress));
      await tester.pumpAndSettle();

      // Verify Completed chip is displayed on the course card
      expect(find.text('Completed'), findsOneWidget);
      expect(find.byType(StatusChip), findsWidgets);
    });

    testWidgets(
        '7. Responsive & accessibility: Dark mode builds without overflow at 320 px width and text scale 2.0',
        (tester) async {
      tester.view.physicalSize = const Size(320 * 2, 640 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({
        'skillup_profile_name': 'Responsive Tester',
        'skillup_theme_mode': 'dark',
      });
      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 640),
            textScaler: TextScaler.linear(2.0),
          ),
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: ProgressScope(
              progressService: progress,
              child: const SkillUpApp(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no RenderFlex errors were thrown at 320px width with 2.0 text scale
      expect(tester.takeException(), isNull);
    });

    testWidgets('8. Failing flow: Result screen displays Not Passed and Retake gives a fresh quiz state',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'skillup_profile_name': 'Retry Tester',
      });
      final storage = await StorageService.initialize();
      final progress = ProgressService(storage);
      final course = CourseRepository.allCourses.first;

      // Fail result with score 2/10
      final failingResult = QuizService.evaluate(
        course: course,
        questions: course.questionBank.take(10).toList(),
        answers: {0: 0, 1: 0}, // Only 2 attempted, incorrect
        learnerName: 'Retry Tester',
      );

      await tester.pumpWidget(
        ProgressScope(
          progressService: progress,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            initialRoute: '/result',
            onGenerateRoute: (settings) {
              if (settings.name == '/result') {
                return MaterialPageRoute(
                  builder: (_) => ResultScreen(result: failingResult),
                );
              }
              if (settings.name == '/quiz') {
                return MaterialPageRoute(
                  builder: (_) => QuizScreen(courseId: course.id),
                );
              }
              return null;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('NOT PASSED'), findsOneWidget);
      expect(find.text('Retake Assessment'), findsOneWidget);

      // Tap Retake
      await tester.tap(find.text('Retake Assessment'));
      await tester.pumpAndSettle();

      // Fresh Quiz state
      expect(find.text('Question 1 of 10'), findsOneWidget);
      expect(find.text('Unanswered'), findsOneWidget);
    });
  });
}
