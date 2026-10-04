import 'package:flutter/material.dart';
import 'models/course.dart';
import 'models/question.dart';
import 'models/quiz_result.dart';
import 'screens/assessment_intro_screen.dart';
import 'screens/certificate_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/learning_path_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/review_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/progress_scope.dart';
import 'theme/app_theme.dart';

class SkillUpApp extends StatelessWidget {
  const SkillUpApp({super.key});

  Route<dynamic> _buildCalmRoute(Widget child, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curve,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);

    return MaterialApp(
      title: 'SkillUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: progress.themeMode,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _buildCalmRoute(const SplashScreen(), settings);
          case '/welcome':
            return _buildCalmRoute(const WelcomeScreen(), settings);
          case '/main':
            return _buildCalmRoute(const MainNavigationScreen(), settings);
          case '/course-detail':
            final courseId = settings.arguments as String? ?? '';
            return _buildCalmRoute(CourseDetailScreen(courseId: courseId), settings);
          case '/learning-path':
            final courseId = settings.arguments as String? ?? '';
            return _buildCalmRoute(LearningPathScreen(courseId: courseId), settings);
          case '/lesson':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final courseId = args['courseId'] as String? ?? '';
            final lessonIndex = args['lessonIndex'] as int? ?? 0;
            return _buildCalmRoute(
              LessonScreen(courseId: courseId, initialLessonIndex: lessonIndex),
              settings,
            );
          case '/assessment-intro':
            final courseId = settings.arguments as String? ?? '';
            return _buildCalmRoute(AssessmentIntroScreen(courseId: courseId), settings);
          case '/quiz':
            final courseId = settings.arguments as String? ?? '';
            return _buildCalmRoute(QuizScreen(courseId: courseId), settings);
          case '/review':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final course = args['course'] as Course;
            final questions = args['questions'] as List<Question>;
            final answers = args['answers'] as Map<int, int>;
            return _buildCalmRoute(
              ReviewScreen(course: course, questions: questions, answers: answers),
              settings,
            );
          case '/result':
            final result = settings.arguments as QuizResult;
            return _buildCalmRoute(ResultScreen(result: result), settings);
          case '/certificate':
            final courseId = settings.arguments as String? ?? '';
            return _buildCalmRoute(CertificateScreen(courseId: courseId), settings);
          default:
            return _buildCalmRoute(const MainNavigationScreen(), settings);
        }
      },
    );
  }
}
