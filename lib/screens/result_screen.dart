import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/quiz_result.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../utils/glitch_page_route.dart';
import '../widgets/wireframe_grid_background.dart';
import '../widgets/hazard_stripe_banner.dart';
import '../widgets/brutal_button.dart';
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
    GlitchPageRoute.pushReplacement(
      context,
      QuizScreen(
        courseService: courseService,
        course: course,
      ),
    );
  }

  void _reviewCourse(BuildContext context) {
    GlitchPageRoute.pushReplacement(
      context,
      LearningHubScreen(
        courseService: courseService,
        courseId: course.id,
      ),
    );
  }

  void _viewCertificate(BuildContext context) {
    GlitchPageRoute.push(
      context,
      CertificateScreen(
        courseService: courseService,
        quizResult: quizResult,
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
          title: const Text('// 05_EVALUATION_OUTCOME'),
          actions: [
            IconButton(
              icon: const Icon(Icons.close_sharp),
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
          ],
        ),
        body: WireframeGridBackground(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hyper-Contrast Indicator Tape
                      if (passed)
                        HazardStripeBanner.pass(
                          text: '>>> PASS_GRANTED // NO_CAP <<<',
                          height: 44.0,
                        )
                      else
                        HazardStripeBanner.fail(
                          text: '>>> HAZARD_FAIL // RETRY_PROTOCOL <<<',
                          height: 44.0,
                        ),

                      const SizedBox(height: 18),

                      // Score Telemetry Inspection Box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          border: Border.all(
                            color: passed ? AppColors.acidGreen : AppColors.glitchCrimson,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  color: passed ? AppColors.acidGreen : AppColors.glitchCrimson,
                                  child: Text(
                                    passed ? '<STATUS: 200_OK>' : '<STATUS: 403_FAIL>',
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'monospace',
                                      color: AppColors.pitchBlack,
                                    ),
                                  ),
                                ),
                                Text(
                                  '// DART_EVAL: ${quizResult.attemptedAt.toIso8601String().substring(11, 19)}',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontFamily: 'monospace',
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // Large Raw Monospace Score
                            Text(
                              '${quizResult.score.toString().padLeft(2, '0')}/${quizResult.totalQuestions.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                letterSpacing: -2.0,
                                color: passed ? AppColors.acidGreen : AppColors.glitchCrimson,
                              ),
                            ),

                            Text(
                              '${quizResult.percentage.toInt()}% FINAL_GRADE_PERCENTILE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                color: isDark ? Colors.white : AppColors.pitchBlack,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Passing Threshold Pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: passed ? AppColors.acidGreen : AppColors.glitchCrimson,
                                border: Border.all(color: AppColors.pitchBlack, width: 1.5),
                              ),
                              child: Text(
                                passed
                                    ? 'VERIFICATION_GRANTED: MET MINIMUM (≥ 60%)'
                                    : 'VERIFICATION_DENIED: BELOW THRESHOLD (< 60%)',
                                style: const TextStyle(
                                  fontSize: 10.5,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              passed
                                  ? 'Operator $learnerName has satisfied all on-device verification criteria. Tamper-evident credential record has been dispatched to local storage buffer.'
                                  : 'Deficiencies detected in module knowledge. Review syllabus nodes and execute re-examination.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                                height: 1.4,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Single-Thumb Velocity Action Bay
                      if (passed) ...[
                        BrutalButton(
                          text: '>>> VIEW_OFFICIAL_CREDENTIAL >>>',
                          onPressed: () => _viewCertificate(context),
                          backgroundColor: AppColors.acidGreen,
                          foregroundColor: AppColors.pitchBlack,
                          shadowColor: isDark ? Colors.white : AppColors.pitchBlack,
                        ),
                        const SizedBox(height: 10),
                        BrutalButton(
                          text: '// RETAKE_ASSESSMENT (RESHUFFLE)',
                          onPressed: () => _retakeAssessment(context),
                          backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE5E5DE),
                          foregroundColor: isDark ? Colors.white : AppColors.pitchBlack,
                          borderWidth: 2.0,
                        ),
                      ] else ...[
                        BrutalButton(
                          text: '>>> RETRY_EXAM_PROTOCOL >>>',
                          onPressed: () => _retakeAssessment(context),
                          backgroundColor: isDark ? Colors.white : AppColors.pitchBlack,
                          foregroundColor: isDark ? AppColors.pitchBlack : AppColors.acidGreen,
                          shadowColor: isDark ? Colors.white : AppColors.pitchBlack,
                        ),
                        const SizedBox(height: 10),
                        BrutalButton(
                          text: '// REVIEW_SYLLABUS_NODES',
                          onPressed: () => _reviewCourse(context),
                          backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE5E5DE),
                          foregroundColor: isDark ? Colors.white : AppColors.pitchBlack,
                          borderWidth: 2.0,
                        ),
                      ],

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                        child: const Text(
                          '// RETURN_TO_ROOT_FEED',
                          style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
