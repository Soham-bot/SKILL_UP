import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/quiz_result.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import 'certificate_screen.dart';
import 'learning_hub_screen.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final CourseService courseService;
  final Course course;
  final QuizResult quizResult;

  const ResultScreen({
    super.key,
    required this.courseService,
    required this.course,
    required this.quizResult,
  });

  void _retakeAssessment(BuildContext context) {
    // Retake logic: Opens QuizScreen fresh.
    // QuizScreen on initState will invoke QuizService.generateRandomQuestions(course)
    // producing a brand-new random shuffle and resetting answers.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          courseService: courseService,
          course: course,
        ),
      ),
    );
  }

  void _reviewCourse(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LearningHubScreen(
          courseService: courseService,
          courseId: course.id,
        ),
      ),
    );
  }

  void _viewCertificate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CertificateScreen(
          courseService: courseService,
          quizResult: quizResult,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final passed = quizResult.passed;
    final learnerName = courseService.profile?.name ?? 'Learner';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Assessment Result'),
          actions: [
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Result Icon
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: passed
                              ? AppColors.success.withOpacity(0.15)
                              : AppColors.danger.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: passed ? AppColors.success : AppColors.danger,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          passed ? Icons.emoji_events_rounded : Icons.replay_rounded,
                          color: passed ? AppColors.success : AppColors.danger,
                          size: 46,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      passed ? 'ASSESSMENT COMPLETE 🎉' : 'ASSESSMENT COMPLETE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Score Display Card
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: passed
                              ? AppColors.success.withOpacity(0.4)
                              : AppColors.danger.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'YOUR SCORE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${quizResult.score}',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: passed ? AppColors.success : AppColors.danger,
                                ),
                              ),
                              Text(
                                ' / ${quizResult.totalQuestions}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${quizResult.percentage.toInt()}%',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: passed ? AppColors.success : AppColors.danger,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Pass/Fail Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: passed
                                  ? AppColors.success.withOpacity(0.15)
                                  : AppColors.danger.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                  size: 16,
                                  color: passed ? AppColors.success : AppColors.danger,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  passed ? '✓ YOU PASSED (≥ 60%)' : '✕ NOT PASSED (< 60%)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: passed ? AppColors.success : AppColors.danger,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            course.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            passed
                                ? 'Outstanding work, $learnerName! You have met the academic threshold and earned your official completion certificate.'
                                : 'Don’t worry, $learnerName. Review the course learning modules and retake the assessment to earn your certificate.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Actions
                    if (passed) ...[
                      FilledButton.icon(
                        onPressed: () => _viewCertificate(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.workspace_premium_rounded, size: 20),
                        label: const Text(
                          'VIEW CERTIFICATE',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => _retakeAssessment(context),
                        child: const Text('Retake Assessment'),
                      ),
                    ] else ...[
                      FilledButton.icon(
                        onPressed: () => _retakeAssessment(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 20),
                        label: const Text(
                          'RETAKE ASSESSMENT',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _reviewCourse(context),
                        icon: const Icon(Icons.menu_book_rounded, size: 16),
                        label: const Text('Review Learning Modules'),
                      ),
                    ],

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      child: const Text('Back to Home Dashboard'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
