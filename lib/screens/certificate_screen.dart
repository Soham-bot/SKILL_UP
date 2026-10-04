import 'package:flutter/material.dart';
import '../data/course_repository.dart';
import '../models/quiz_result.dart';
import '../services/certificate_pdf_service.dart';
import '../services/progress_scope.dart';
import '../widgets/certificate_view.dart';
import '../widgets/empty_state.dart';
import '../widgets/responsive_container.dart';

class CertificateScreen extends StatefulWidget {
  final String courseId;

  const CertificateScreen({super.key, required this.courseId});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  bool _isGeneratingPdf = false;

  Future<void> _downloadOrSharePdf(QuizResult result) async {
    if (_isGeneratingPdf) return;
    setState(() => _isGeneratingPdf = true);

    try {
      final success = await CertificatePdfService.shareOrSave(result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Certificate PDF ready. File saved/shared.'
                  : 'PDF generated successfully.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not generate PDF. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
    }
  }

  Future<void> _print(QuizResult result) async {
    try {
      await CertificatePdfService.printCertificate(result);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not initiate printing. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = ProgressScope.of(context);
    final course = CourseRepository.getById(widget.courseId);
    final bestResult = progress.getBestResult(widget.courseId);

    // Guard: Certificate is only accessible if the course is passed
    if (course == null || bestResult == null || !bestResult.passed) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(title: const Text('Certificate')),
        body: EmptyState(
          icon: Icons.lock_outline,
          title: 'Certificate Not Available Yet',
          message:
              'Complete the lessons and score 60% or higher on the final assessment to earn your official certificate.',
          actionLabel: 'Go to Course',
          onAction: () {
            Navigator.of(context).pushReplacementNamed(
              '/course-detail',
              arguments: widget.courseId,
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Your Certificate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Print Certificate',
            onPressed: () => _print(bestResult),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Certificate',
            onPressed: () => _downloadOrSharePdf(bestResult),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          maxWidth: 720,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Notice banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, size: 20, color: colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Verified On-Device Certification. Rendered from immutable cryptographic evaluation.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // The Visual Certificate Widget (Must look good in light & dark modes)
              CertificateView(result: bestResult),
              const SizedBox(height: 28),

              // Actions: Download PDF (Primary), Print, Share
              FilledButton.icon(
                onPressed: _isGeneratingPdf
                    ? null
                    : () => _downloadOrSharePdf(bestResult),
                icon: _isGeneratingPdf
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf_outlined),
                label: Text(
                  _isGeneratingPdf ? 'Generating PDF...' : 'Download PDF Certificate',
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.print_outlined),
                      label: const Text('Print'),
                      onPressed: () => _print(bestResult),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Share'),
                      onPressed: () => _downloadOrSharePdf(bestResult),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/main',
                    (route) => false,
                  );
                },
                child: const Text('Return to Course Catalog'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
