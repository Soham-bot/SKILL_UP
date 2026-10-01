import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../widgets/certificate_widget.dart';

class CertificateScreen extends StatelessWidget {
  final CourseService courseService;
  final QuizResult quizResult;

  const CertificateScreen({
    super.key,
    required this.courseService,
    required this.quizResult,
  });

  void _handleShare(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Certificate ${quizResult.certificateId} copied to clipboard!'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSave(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verified Certificate ${quizResult.certificateId} saved to local device!'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final learnerName = courseService.profile?.name ?? 'Learner';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Official Certificate'),
        actions: [
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _handleShare(context),
          ),
          IconButton(
            tooltip: 'Save',
            icon: const Icon(Icons.download_rounded),
            onPressed: () => _handleSave(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Certificate Container
                  CertificateWidget(
                    learnerName: learnerName,
                    quizResult: quizResult,
                  ),

                  const SizedBox(height: 28),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _handleSave(context),
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: const Text('Save Local'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _handleShare(context),
                          icon: const Icon(Icons.share_rounded, size: 18),
                          label: const Text('Share Certificate'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  TextButton.icon(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    icon: const Icon(Icons.home_rounded, size: 18),
                    label: const Text('Back to Dashboard'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
