import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/quiz_result.dart';

class CertificatePdfService {
  /// Builds standard A4 landscape PDF bytes for a given QuizResult.
  /// Must return non-empty bytes starting with '%PDF'.
  static Future<Uint8List> build(QuizResult result) async {
    final pdf = pw.Document();

    // Fonts: Use standard PDF built-in fonts (Times / Helvetica) to ensure 100% offline reliability
    final fontSerifBold = pw.Font.timesBold();
    final fontSerifItalic = pw.Font.timesItalic();
    final fontSans = pw.Font.helvetica();
    final fontSansBold = pw.Font.helveticaBold();

    final navyColor = PdfColor.fromInt(0xFF2B3A67);
    final goldColor = PdfColor.fromInt(0xFFB08D57);
    final ivoryBg = PdfColor.fromInt(0xFFFAF8F4);
    final textDark = PdfColor.fromInt(0xFF1F2430);
    final textMuted = PdfColor.fromInt(0xFF6B7280);
    final sageColor = PdfColor.fromInt(0xFF4F7F6A);

    final dateFormatted =
        '${_monthName(result.completedAt.month)} ${result.completedAt.day}, ${result.completedAt.year}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              color: ivoryBg,
              border: pw.Border.all(color: navyColor, width: 4),
            ),
            padding: const pw.EdgeInsets.all(12),
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: goldColor, width: 1.5),
              ),
              padding: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 20),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Top Wordmark & Title
                  pw.Column(
                    children: [
                      pw.Text(
                        'SKILLUP',
                        style: pw.TextStyle(
                          font: fontSansBold,
                          fontSize: 16,
                          letterSpacing: 4,
                          color: navyColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'CERTIFICATE OF COMPLETION',
                        style: pw.TextStyle(
                          font: fontSerifBold,
                          fontSize: 22,
                          letterSpacing: 2,
                          color: goldColor,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Text(
                        'This is to certify that',
                        style: pw.TextStyle(
                          font: fontSans,
                          fontSize: 12,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),

                  // Learner Name
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: pw.FittedBox(
                      fit: pw.BoxFit.scaleDown,
                      child: pw.Text(
                        result.learnerName,
                        style: pw.TextStyle(
                          font: fontSerifItalic,
                          fontSize: 32,
                          color: navyColor,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),

                  // Course & Achievement
                  pw.Column(
                    children: [
                      pw.Text(
                        'has successfully completed the course',
                        style: pw.TextStyle(
                          font: fontSans,
                          fontSize: 12,
                          color: textMuted,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        result.courseTitle,
                        style: pw.TextStyle(
                          font: fontSerifBold,
                          fontSize: 20,
                          color: textDark,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 8),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: pw.BoxDecoration(
                          color: sageColor,
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                        ),
                        child: pw.Text(
                          'PASSED  ·  SCORE: ${result.score}/${result.totalQuestions} (${result.percentage.toStringAsFixed(0)}%)',
                          style: pw.TextStyle(
                            font: fontSansBold,
                            fontSize: 10,
                            letterSpacing: 1,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Bottom Row: Date, Seal, Signature
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      // Date
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            dateFormatted,
                            style: pw.TextStyle(
                              font: fontSansBold,
                              fontSize: 11,
                              color: textDark,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Container(width: 120, height: 1, color: navyColor),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Date of Issue',
                            style: pw.TextStyle(
                              font: fontSans,
                              fontSize: 9,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),

                      // Decorative Emblem / Seal (Vector Shapes)
                      pw.Container(
                        width: 54,
                        height: 54,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(color: goldColor, width: 2),
                        ),
                        child: pw.Center(
                          child: pw.Container(
                            width: 44,
                            height: 44,
                            decoration: pw.BoxDecoration(
                              shape: pw.BoxShape.circle,
                              border: pw.Border.all(color: navyColor, width: 1),
                            ),
                            child: pw.Center(
                              child: pw.Text(
                                'OFFICIAL\nSEAL\nVERIFIED',
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  font: fontSansBold,
                                  fontSize: 6,
                                  color: goldColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Signature Line
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'SkillUp Certification Board',
                            style: pw.TextStyle(
                              font: fontSerifItalic,
                              fontSize: 12,
                              color: navyColor,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Container(width: 140, height: 1, color: navyColor),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Authorized Signature',
                            style: pw.TextStyle(
                              font: fontSans,
                              fontSize: 9,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Bottom Certificate ID
                  pw.Text(
                    'CERTIFICATE ID: ${result.id}',
                    style: pw.TextStyle(
                      font: fontSans,
                      fontSize: 8.5,
                      letterSpacing: 2,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Shares or saves the generated PDF through Printing.sharePdf
  static Future<bool> shareOrSave(QuizResult result) async {
    final bytes = await build(result);
    final sanitizedCourse =
        result.courseTitle.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final sanitizedName =
        result.learnerName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final filename = 'SkillUp_${sanitizedCourse}_$sanitizedName.pdf';

    return Printing.sharePdf(
      bytes: bytes,
      filename: filename,
    );
  }

  /// Direct print through Printing
  static Future<void> printCertificate(QuizResult result) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => build(result),
      name: 'SkillUp_Certificate_${result.id}',
    );
  }

  static String _monthName(int month) {
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
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}
