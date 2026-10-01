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
        content: Text(
          '// CREDENTIAL_HASH_COPIED: [${quizResult.certificateId}]',
          style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.pitchBlack,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSave(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '// CREDENTIAL_SAVED_TO_ON_DEVICE_STORAGE // SERIAL: ${quizResult.certificateId}',
          style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.acidGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final learnerName = courseService.profile?.name ?? 'OPERATOR';

    return Scaffold(
      appBar: AppBar(
        title: const Text('// OFFICIAL_CREDENTIAL'),
        actions: [
          IconButton(
            tooltip: 'SHARE_HASH',
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _handleShare(context),
          ),
          IconButton(
            tooltip: 'DOWNLOAD_LOCAL',
            icon: const Icon(Icons.download_rounded),
            onPressed: () => _handleSave(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CertificateWidget(
                    learnerName: learnerName,
                    quizResult: quizResult,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _handleSave(context),
                          child: const Text('// SAVE_LOCAL'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _handleShare(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.acidGreen,
                            foregroundColor: AppColors.pitchBlack,
                          ),
                          child: const Text('SHARE_HASH'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Text(
                      '// RETURN_TO_ROOT',
                      style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900),
                    ),
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
