import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quiz_result.dart';
import '../theme/app_theme.dart';

class CertificateView extends StatelessWidget {
  final QuizResult result;

  const CertificateView({super.key, required this.result});

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final month = (date.month >= 1 && date.month <= 12) ? months[date.month - 1] : '';
    return '$month ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColors = theme.extension<AppStatusColors>() ?? AppStatusColors.light;

    // Certificate paper stays authentic ivory in both light and dark themes
    final paperBg = statusColors.certificateIvory;
    final navyColor = statusColors.certificateNavy;
    final goldColor = statusColors.certificateGold;
    final textDark = statusColors.certificateNavy;
    final textMuted = statusColors.certificateNavy.withOpacity(0.7);

    return Container(
      decoration: BoxDecoration(
        color: paperBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: navyColor, width: 3.5),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: goldColor, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Organization Header
            Text(
              'SKILLUP',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
                color: navyColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'CERTIFICATE OF COMPLETION',
              style: GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: goldColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),

            Text(
              'This is to certify that',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 10),

            // Learner Name — Auto scales (FittedBox) for long names up to 50 chars
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              constraints: const BoxConstraints(maxWidth: 500),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  result.learnerName,
                  style: GoogleFonts.fraunces(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: navyColor,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              'has successfully completed the course',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 6),

            // Course Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                result.courseTitle,
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),

            // Passed Badge & Score
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: statusColors.success,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 14, color: statusColors.onSuccess),
                  const SizedBox(width: 6),
                  Text(
                    'PASSED  ·  SCORE: ${result.score}/${result.totalQuestions} (${result.percentage.toStringAsFixed(0)}%)',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: statusColors.onSuccess,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Bottom Meta: Date, Seal, Signature
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Issue Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatDate(result.completedAt),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(width: 90, height: 1, color: navyColor),
                    const SizedBox(height: 2),
                    Text(
                      'Date of Issue',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),

                // Center Emblem / Seal
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: goldColor, width: 2),
                  ),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: navyColor, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          'OFFICIAL\nSEAL',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 7,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: goldColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Authorized Signature
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SkillUp Certification Board',
                      style: GoogleFonts.fraunces(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: navyColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(width: 130, height: 1, color: navyColor),
                    const SizedBox(height: 2),
                    Text(
                      'Authorized Signature',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Certificate ID
            SelectableText(
              'CERTIFICATE ID: ${result.id}',
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
