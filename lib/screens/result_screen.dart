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
    final learnerName = courseService.profile?.name ?? 'OPERATOR';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('// EVALUATION_OUTCOME'),
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
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hazard / Success Banner Strip
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      color: passed ? AppColors.acidGreen : AppColors.glitchCrimson,
                      child: Text(
                        passed ? '>>> PASS_GRANTED // NO_CAP <<<' : '>>> HAZARD_FAIL // RETRY_PROTOCOL <<<',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: AppColors.pitchBlack,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Score Inspection Box
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        border: Border.all(
                          color: passed
                              ? AppColors.acidGreen
                              : AppColors.glitchCrimson,
                          width: 3.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: passed ? AppColors.acidGreen : AppColors.glitchCrimson,
                            offset: const Offset(5, 5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '// COMPUTED_TELEMETRY:',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Large Raw Monospace Score
                          Text(
                            '${quizResult.score.toString().padLeft(2, '0')} / ${quizResult.totalQuestions.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: passed ? AppColors.acidGreen : AppColors.glitchCrimson,
                            ),
                          ),

                          Text(
                            '${quizResult.percentage.toInt()}% FINAL_GRADE',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: isDark ? Colors.white : AppColors.pitchBlack,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            color: passed ? AppColors.acidGreen : AppColors.glitchCrimson,
                            child: Text(
                              passed ? 'GRADE: PASS (THRESHOLD ≥ 60%)' : 'GRADE: FAIL (BELOW 60%)',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                color: AppColors.pitchBlack,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            course.title.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            passed
                                ? 'Operator $learnerName has officially passed the on-device verification matrix. Certificate protocol generated.'
                                : 'Threshold not met. Review syllabus modules and re-execute assessment.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Actions
                    if (passed) ...[
                      FilledButton(
                        onPressed: () => _viewCertificate(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.acidGreen,
                          foregroundColor: AppColors.pitchBlack,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('>>> VIEW_OFFICIAL_CREDENTIAL >>>'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () => _retakeAssessment(context),
                        child: const Text('// RETAKE_ASSESSMENT'),
                      ),
                    ] else ...[
                      FilledButton(
                        onPressed: () => _retakeAssessment(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : AppColors.pitchBlack,
                          foregroundColor: isDark ? AppColors.pitchBlack : AppColors.acidGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('>>> RETRY_EXAM_PROTOCOL >>>'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () => _reviewCourse(context),
                        child: const Text('// REVIEW_SYLLABUS'),
                      ),
                    ],

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      child: const Text('// RETURN_TO_ROOT', style: TextStyle(fontFamily: 'monospace')),
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
