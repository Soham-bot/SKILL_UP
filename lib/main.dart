import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/course_service.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations for consistent cross-platform presentation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final courseService = CourseService();
  await courseService.initialize();

  runApp(SkillUpApp(courseService: courseService));
}

class SkillUpApp extends StatelessWidget {
  final CourseService courseService;

  const SkillUpApp({super.key, required this.courseService});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: courseService,
      builder: (context, _) {
        final hasProfile = courseService.profile != null &&
            courseService.profile!.name.trim().isNotEmpty;

        return MaterialApp(
          title: 'SkillUp',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: courseService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: hasProfile
              ? MainNavigationScreen(courseService: courseService)
              : WelcomeScreen(courseService: courseService),
        );
      },
    );
  }
}
