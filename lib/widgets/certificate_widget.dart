import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import '../theme/app_colors.dart';
import '../utils/certificate_utils.dart';

class CertificateWidget extends StatelessWidget {
  final String learnerName;
  final QuizResult quizResult;

  const CertificateWidget({
    super.key,
    required this.learnerName,
    required this.quizResult,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C0C0C) : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
          width: 3.0, // Hard 3px solid brutalist border
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
            offset: const Offset(6, 6), // 6px hard shadow
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Barcode & Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SKILLUP // PROTOCOL_CERT_V1',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                  color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: AppColors.acidGreen,
                child: const Text(
                  'PASS_GRANTED // NO_CAP',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: AppColors.pitchBlack,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ASCII Barcode Simulation Strip
          Container(
            height: 24,
            width: double.infinity,
            color: isDark ? Colors.white : AppColors.pitchBlack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(36, (index) {
                final isSpace = (index % 3 == 0) || (index % 7 == 0);
                return Container(
                  width: isSpace ? 4 : 2,
                  height: double.infinity,
                  color: isDark ? AppColors.pitchBlack : Colors.white,
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // Certificate Title Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white : AppColors.pitchBlack,
            ),
            child: Text(
              'OFFICIAL_VERIFIED_CREDENTIAL',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                letterSpacing: 2.0,
                color: isDark ? AppColors.pitchBlack : AppColors.acidGreen,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            '// CERTIFIES_THAT_OPERATOR:',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),

          const SizedBox(height: 6),

          // Learner Name Display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161616) : const Color(0xFFF0F0EC),
              border: Border.all(
                color: isDark ? Colors.white : AppColors.pitchBlack,
                width: 2,
              ),
            ),
            child: Text(
              learnerName.toUpperCase(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                letterSpacing: 1.0,
                color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            '// HAS_DEMONSTRATED_MASTERY_IN_NODE:',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),

          const SizedBox(height: 6),

          // Course Title
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161616) : const Color(0xFFF0F0EC),
              border: Border.all(
                color: isDark ? Colors.white : AppColors.pitchBlack,
                width: 2,
              ),
            ),
            child: Text(
              quizResult.courseTitle.toUpperCase(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                color: isDark ? Colors.white : AppColors.pitchBlack,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Score Terminal Box
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.acidGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'COMPUTED_SCORE:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: AppColors.pitchBlack,
                  ),
                ),
                Text(
                  '${quizResult.score}/10 [${quizResult.percentage.toInt()}%] // VERIFIED',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: AppColors.pitchBlack,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Metadata Grid: Serial ID & Date
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '// CERT_ID:',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quizResult.certificateId,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: isDark ? Colors.white : AppColors.pitchBlack,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '// ISSUE_TIMESTAMP:',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CertificateUtils.formatDate(quizResult.attemptedAt).toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: isDark ? Colors.white : AppColors.pitchBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
