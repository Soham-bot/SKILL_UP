import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../widgets/wireframe_grid_background.dart';
import '../widgets/certificate_widget.dart';
import '../widgets/brutal_button.dart';

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
          '// CREDENTIAL_SAVED_TO_BUFFER // SERIAL: ${quizResult.certificateId}',
          style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.acidGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final learnerName = courseService.profile?.name ?? 'OPERATOR';

    return Scaffold(
      appBar: AppBar(
        title: const Text('// OFFICIAL_CREDENTIAL'),
        actions: [
          IconButton(
            tooltip: 'SHARE_HASH',
            icon: const Icon(Icons.share_sharp),
            onPressed: () => _handleShare(context),
          ),
          IconButton(
            tooltip: 'DOWNLOAD_LOCAL',
            icon: const Icon(Icons.download_sharp),
            onPressed: () => _handleSave(context),
          ),
        ],
      ),
      body: WireframeGridBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CertificateWidget(
                      learnerName: learnerName,
                      quizResult: quizResult,
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: BrutalButton(
                            text: '// SAVE_LOCAL',
                            onPressed: () => _handleSave(context),
                            backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE5E5DE),
                            foregroundColor: isDark ? Colors.white : AppColors.pitchBlack,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: BrutalButton(
                            text: 'SHARE_HASH',
                            onPressed: () => _handleShare(context),
                            backgroundColor: AppColors.acidGreen,
                            foregroundColor: AppColors.pitchBlack,
                            shadowColor: isDark ? Colors.white : AppColors.pitchBlack,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      child: const Text(
                        '// RETURN_TO_ROOT_FEED',
                        style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900),
                      ),
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
