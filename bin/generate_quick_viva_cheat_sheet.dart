import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() async {
  final pdf = pw.Document();

  const navy = PdfColor.fromInt(0xFF2B3A67);
  const gold = PdfColor.fromInt(0xFFB08D57);
  const darkInk = PdfColor.fromInt(0xFF1F2430);
  const sage = PdfColor.fromInt(0xFF4F7F6A);
  const cardBg = PdfColor.fromInt(0xFFF8F9FC);
  const borderCol = PdfColor.fromInt(0xFFDDE1EE);

  pw.Widget buildBox({
    required String title,
    required List<pw.Widget> children,
    PdfColor headerColor = navy,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      decoration: pw.BoxDecoration(
        color: cardBg,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: borderCol, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: pw.BoxDecoration(
              color: headerColor,
              borderRadius: const pw.BorderRadius.vertical(top: pw.Radius.circular(5)),
            ),
            child: pw.Row(
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // PAGE 1: 30-SEC INTRO & LIVE DEMO SCRIPT
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Top Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'SKILLUP • VIVA CHEAT SHEET (30-MIN PREP)',
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: gold),
                ),
                pw.Text('Candidate: Soham Ahirrao', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Easy Presentation Script & Examiner Q&A Guide',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: navy),
            ),
            pw.SizedBox(height: 8),
            pw.Divider(color: gold, thickness: 1.2),
            pw.SizedBox(height: 8),

            // BOX 1: 30-SECOND OPENING
            buildBox(
              title: 'STEP 1: YOUR 30-SECOND OPENING (MEMORIZE THIS)',
              headerColor: navy,
              children: [
                pw.Text(
                  '"Good morning, professors. My project is SkillUp, an offline skill-certification platform built 100% in Flutter.\n\n'
                  'Most quiz apps are just web-views that need an internet connection for everything. SkillUp is completely different: it runs 100% on-device. Learners enroll in courses, read structured lessons with real enterprise case studies, take an assessment, and instantly get a verified PDF certificate without needing any backend server or WiFi.\n\n'
                  'Let me give you a quick 2-minute live demo of the complete flow."',
                  style: pw.TextStyle(fontSize: 10.5, height: 1.35, color: darkInk, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),

            // BOX 2: 5-STEP DEMO GUIDE
            buildBox(
              title: 'STEP 2: THE 2-MINUTE LIVE DEMO (WHAT TO TAP & WHAT TO SAY)',
              headerColor: navy,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('1. Welcome Screen: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: navy)),
                    pw.Expanded(
                      child: pw.Text(
                        'Tap the name box. Say: "We validate the learner’s name locally (2-50 letters). The continue button stays disabled until it’s valid. It is saved in local SharedPreferences."',
                        style: const pw.TextStyle(fontSize: 9.5, height: 1.25),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('2. Home Catalog: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: navy)),
                    pw.Expanded(
                      child: pw.Text(
                        'Show the 4 courses. Say: "This is Material 3 with a quiet royal palette. On mobile it’s a ListView, but on tablets or web it automatically turns into a multi-column GridView using LayoutBuilder."',
                        style: const pw.TextStyle(fontSize: 9.5, height: 1.25),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('3. Learning Path: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: navy)),
                    pw.Expanded(
                      child: pw.Text(
                        'Tap "Flutter Fundamentals", then "Enroll for free". Say: "Notice the 5 lessons. The Final Assessment at the bottom is LOCKED until all 5 lessons are finished. You cannot skip straight to the quiz."',
                        style: const pw.TextStyle(fontSize: 9.5, height: 1.25),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('4. Quiz & Scoring: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: navy)),
                    pw.Expanded(
                      child: pw.Text(
                        'Answer questions. Tap "Need a hint?". Say: "The engine picks 10 random questions covering every lesson. Hints use Dart sound null-safety. Tapping back has a PopScope guard so you don’t lose progress."',
                        style: const pw.TextStyle(fontSize: 9.5, height: 1.25),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('5. Certificate & PDF: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: navy)),
                    pw.Expanded(
                      child: pw.Text(
                        'Submit. Show 80% Pass. Tap "View certificate". Say: "The score was calculated instantly in Dart. The certificate is built dynamically with a unique ID, and tapping Download generates an official A4 PDF directly on the phone."',
                        style: const pw.TextStyle(fontSize: 9.5, height: 1.25),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // BOX 3: 15-SECOND CLOSING
            buildBox(
              title: 'STEP 3: YOUR 15-SECOND CLOSING',
              headerColor: sage,
              children: [
                pw.Text(
                  '"In short, SkillUp proves that Flutter can deliver complete, responsive, server-less mobile applications with 60 FPS performance, zero crashes, and real PDF generation. The code passes flutter analyze with 0 warnings and all 25 tests are green. Thank you, I am ready for questions."',
                  style: pw.TextStyle(fontSize: 10, height: 1.3, color: darkInk, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  // PAGE 2: THE 4 EXAMINER QUESTIONS (THE ONLY ONES THEY WILL ASK)
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'EXAMINER Q&A CHEAT SHEET (JUST REMEMBER THESE 4)',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: navy),
            ),
            pw.SizedBox(height: 4),
            pw.Text('If the professors ask you technical questions, give these exact 2-sentence answers:', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            pw.SizedBox(height: 8),
            pw.Divider(color: gold, thickness: 1.2),
            pw.SizedBox(height: 10),

            buildBox(
              title: 'Q1: "Why did you use Flutter instead of React Native?"',
              headerColor: navy,
              children: [
                pw.Text(
                  'SAY THIS: "React Native uses a JavaScript bridge to talk to native widgets, which causes UI lag and dropped frames. Flutter compiles Dart directly into native ARM machine code using its own Impeller rendering engine, giving smooth 60 to 120 FPS animations with zero bridge bottlenecks."',
                  style: pw.TextStyle(fontSize: 10, height: 1.35, color: darkInk),
                ),
              ],
            ),

            buildBox(
              title: 'Q2: "Why ChangeNotifier? Why not Riverpod or Bloc?"',
              headerColor: navy,
              children: [
                pw.Text(
                  'SAY THIS: "Bloc and Riverpod add heavy third-party boilerplate and extra package dependencies. For an offline on-device app, Flutter’s built-in ChangeNotifier combined with InheritedNotifier gives us clean state management, instant O(1) context lookups, and 100% testability without adding a single extra library."',
                  style: pw.TextStyle(fontSize: 10, height: 1.35, color: darkInk),
                ),
              ],
            ),

            buildBox(
              title: 'Q3: "How do you calculate the score without a backend server?"',
              headerColor: navy,
              children: [
                pw.Text(
                  'SAY THIS: "We built QuizService.evaluate in pure Dart. It runs a loop comparing the learner’s chosen answers with the correct option index, computes the percentage, and checks if it’s >= 60%. Because it runs in compiled Dart on-device, it takes under 5 milliseconds and works completely without internet."',
                  style: pw.TextStyle(fontSize: 10, height: 1.35, color: darkInk),
                ),
              ],
            ),

            buildBox(
              title: 'Q4: "How does the PDF certificate download work offline?"',
              headerColor: navy,
              children: [
                pw.Text(
                  'SAY THIS: "We use the Dart pdf package, which draws vector shapes, seals, and typography directly into a binary PDF byte stream in memory. Then the printing package passes those bytes to the native OS share and print dialog on Android, iOS, Mac, or Web."',
                  style: pw.TextStyle(fontSize: 10, height: 1.35, color: darkInk),
                ),
              ],
            ),

            // GOLDEN BUZZWORDS BOX
            buildBox(
              title: '5 FLUTTER BUZZWORDS TO DROP CASUALLY (IMPRESSES EXAMINERS)',
              headerColor: gold,
              children: [
                pw.Bullet(text: 'Three-Tree Architecture: "Flutter maintains the Widget tree, Element tree, and RenderObject tree."', style: const pw.TextStyle(fontSize: 9.5)),
                pw.Bullet(text: 'Sound Null Safety: "Dart eliminates null-pointer runtime crashes before deployment."', style: const pw.TextStyle(fontSize: 9.5)),
                pw.Bullet(text: 'Material 3 Theming: "All colors derive from ColorScheme.fromSeed with zero hardcoded colors."', style: const pw.TextStyle(fontSize: 9.5)),
                pw.Bullet(text: 'LayoutBuilder: "Responsive design that adapts between phone ListView and tablet GridView."', style: const pw.TextStyle(fontSize: 9.5)),
                pw.Bullet(text: 'PopScope: "Prevents accidental back-button swipes so quiz progress is never lost."', style: const pw.TextStyle(fontSize: 9.5)),
              ],
            ),
          ],
        );
      },
    ),
  );

  final bytes = await pdf.save();
  final file = File('SkillUp_Quick_Viva_CheatSheet.pdf');
  await file.writeAsBytes(bytes);
  stdout.writeln('Successfully generated ${file.path} (${bytes.length} bytes)');
}
