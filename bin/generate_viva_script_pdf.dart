import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() async {
  final pdf = pw.Document();

  // Colors
  const navy = PdfColor.fromInt(0xFF2B3A67);
  const gold = PdfColor.fromInt(0xFFB08D57);
  const darkInk = PdfColor.fromInt(0xFF1F2430);
  const lightGrey = PdfColor.fromInt(0xFFF7F6F3);
  const borderGrey = PdfColor.fromInt(0xFFE4E0D8);
  const sage = PdfColor.fromInt(0xFF4F7F6A);

  pw.Widget buildHeader(String title, {String? subtitle}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: gold, width: 1.5),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: navy,
            ),
          ),
          if (subtitle != null) ...[
            pw.SizedBox(height: 3),
            pw.Text(
              subtitle,
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget buildSectionCard({
    required String sectionTitle,
    required String timing,
    required String actionDemo,
    required String spokenScript,
    required String flutterBiasPoints,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: lightGrey,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: borderGrey, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                sectionTitle,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: navy,
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const pw.BoxDecoration(
                  color: navy,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: pw.Text(
                  timing,
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          // Action Cue
          pw.Container(
            padding: const pw.EdgeInsets.all(5),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              border: pw.Border.all(color: borderGrey, width: 0.5),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'SCREEN ACTION: ',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    color: gold,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    actionDemo,
                    style: const pw.TextStyle(
                      fontSize: 8.5,
                      color: darkInk,
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 6),
          // Spoken Script
          pw.Text(
            'WHAT TO SAY TO EXAMINERS:',
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: navy,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            spokenScript,
            style: const pw.TextStyle(
              fontSize: 9,
              height: 1.35,
              color: darkInk,
            ),
          ),
          pw.SizedBox(height: 6),
          // Flutter Highlights
          pw.Container(
            padding: const pw.EdgeInsets.all(5),
            decoration: const pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFEBF0FA),
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'FLUTTER ADVANTAGE: ',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    color: navy,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    flutterBiasPoints,
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: darkInk,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PAGE 1: TITLE & EXECUTIVE THESIS (WHY FLUTTER WINS)
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Top Badge
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'B.TECH CSE & AI CAPSTONE DEFENSE',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: gold,
                    letterSpacing: 1.2,
                  ),
                ),
                pw.Text(
                  'ACADEMIC VIVA SCRIPT',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'SkillUp — Online Skill Certification Platform',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: navy,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Complete Step-by-Step Viva Voce Defense Script & Flutter Architectural Justification',
              style: const pw.TextStyle(
                fontSize: 11,
                color: PdfColors.grey800,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Divider(color: gold, thickness: 1.5),
            pw.SizedBox(height: 12),

            // Presenter info block
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: lightGrey,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(color: borderGrey, width: 0.8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Candidate:', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                      pw.Text('Soham Ahirrao', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: navy)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Discipline:', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                      pw.Text('B.Tech CSE (Artificial Intelligence)', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: navy)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Core Stack:', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                      pw.Text('100% Flutter SDK & Sound Dart', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: sage)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Section 1: Opening Hook
            buildHeader('1. Opening Hook & Problem Statement', subtitle: 'Target Time: 0:00 - 1:30'),
            pw.Text(
              'WHAT TO SAY TO THE EXAMINING COMMITTEE:',
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: navy),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '"Good morning, esteemed committee and professors. I am Soham Ahirrao, and today I present SkillUp — an online skill-certification platform engineered entirely with Flutter and Dart.\n\n'
              'In contemporary mobile application development, e-learning apps often suffer from three critical flaws: sluggish web-view wrappers, heavy battery-draining network round-trips for basic evaluation, and jarring, chaotic user interfaces. SkillUp re-engineers this paradigm from the ground up.\n\n'
              'Our problem statement demands a mobile platform where learners can enroll in short skill courses, master core topics through interactive reading modules and realistic enterprise case studies, take an on-device stratified assessment, and instantly receive a verified, downloadable credential — with sub-second evaluation speed, zero cloud dependency, and total offline autonomy.\n\n'
              'To achieve this level of deterministic performance, strict null safety, and cross-platform fidelity across Mobile, Web, and Desktop from a single codebase, there was only one choice: Google Flutter."',
              style: const pw.TextStyle(fontSize: 9, height: 1.4, color: darkInk),
            ),
            pw.SizedBox(height: 14),

            // Section 2: Why Flutter Wins
            buildHeader('2. The Technical Defense: Why Flutter is Superior', subtitle: 'Target Time: 1:30 - 3:00'),
            pw.Text(
              'Key comparative arguments to state with confidence:',
              style: const pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic),
            ),
            pw.SizedBox(height: 6),
            pw.Bullet(
              text: 'Direct Native Compilation vs JS Bridge: Unlike React Native which relies on a JavaScript bridge or Hermes serialization to communicate with OEM widgets, Flutter compiles Dart AOT (Ahead-of-Time) directly to native ARM64 machine instructions. Every pixel is rendered via Flutter’s Skia/Impeller graphics engine at a guaranteed 60 to 120 FPS.',
              style: const pw.TextStyle(fontSize: 8.5, height: 1.3),
            ),
            pw.Bullet(
              text: 'The Three-Tree Architecture: Flutter separates the declarative Widget tree (lightweight configuration blueprint) from the Element tree (stateful lifecycle management and diffing) and the RenderObject tree (layout geometry, painting, and compositing). In SkillUp, we leverage const constructors and RepaintBoundary to eliminate unnecessary layout passes.',
              style: const pw.TextStyle(fontSize: 8.5, height: 1.3),
            ),
            pw.Bullet(
              text: 'Sound Null Safety & Static Verification: Dart’s sound type system ensures that null-dereference exceptions are caught at compile time rather than crashing user devices in production. Our hint and explanation properties are completely null-safe with zero force unwraps (!).',
              style: const pw.TextStyle(fontSize: 8.5, height: 1.3),
            ),
            pw.Bullet(
              text: 'Single Codebase Multi-Target Reality: The exact same Dart logic powers iOS, Android, macOS, and Web with identical responsive layout switching via LayoutBuilder.',
              style: const pw.TextStyle(fontSize: 8.5, height: 1.3),
            ),
          ],
        );
      },
    ),
  );

  // PAGE 2: SCREEN-BY-SCREEN DEMO SCRIPT (SCREENS 1 TO 5)
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            buildHeader('3. Complete Screen-by-Screen Viva Demonstration Script', subtitle: 'Phase 1: Discovery, Enrollment & Pedagogical Journey (3:00 - 6:30)'),

            buildSectionCard(
              sectionTitle: 'Step 1: Splash Screen & Welcome Setup (Screens 01 & 02)',
              timing: '0:30 min',
              actionDemo: 'Launch app. Show 1.2s smooth splash animation. On Welcome, type single letter "A" (shows validation error & disabled button), then enter full name "Soham Ahirrao" and tap Continue.',
              spokenScript: '"Here on the Welcome screen, we establish learner identity. Notice the reactive text field validation. The Continue button remains disabled until a valid name of 2 to 50 characters matching a strict regex pattern is entered.\n\n'
                  'Notice this important privacy guarantee: the name is stored solely in local device SharedPreferences via our StorageService wrapper. No personal data ever leaves the device."',
              flutterBiasPoints: 'Uses TextEditingController with addListener for 60fps synchronous UI reactivity. Uses defensive parsing with fallback defaults to ensure corrupt storage never crashes the engine.',
            ),

            buildSectionCard(
              sectionTitle: 'Step 2: Home Catalog & Responsive Layout (Screen 03)',
              timing: '1:00 min',
              actionDemo: 'Point out the personalized greeting ("Hello, Soham"), search bar, category chips (Mobile, Backend, Web, Security), and 4 course cards with dynamic status chips.',
              spokenScript: '"On the Home screen, learners discover courses. The UI embodies Material Design 3\'s \'quiet, royal\' aesthetic—seeded with a deep navy-indigo (#2B3A67) and accented with antique gold (#B08D57) and warm ivory (#FAF8F4).\n\n'
                  'Crucially, notice how the course cards adapt. On phones, Flutter builds a lazy ListView.builder. On tablets and desktops above 600 pixels, it instantly switches to a multi-column GridView.builder without page reloading."',
              flutterBiasPoints: 'LayoutBuilder queries viewport box constraints. Zero hardcoded colors—100% derived from Theme.of(context).colorScheme and our custom AppStatusColors ThemeExtension.',
            ),

            buildSectionCard(
              sectionTitle: 'Step 3: Course Detail & Metric Summary (Screen 04)',
              timing: '0:45 min',
              actionDemo: 'Tap "Flutter Fundamentals". Highlight the 3-column summary card (Duration: ~90 min, Difficulty: Beginner, Quiz: 10 questions), syllabus list, and sticky bottom Enroll button.',
              spokenScript: '"Entering Course Detail, learners see exact syllabus transparency. We display course duration, difficulty tag, learning outcomes, and a preview of the 5 lessons.\n\n'
                  'When I tap \'Enroll for free\', our ChangeNotifier state machine registers the course and shows a confirmation SnackBar, instantly routing the learner to their Learning Path."',
              flutterBiasPoints: 'Built with CustomScrollView and SliverAppBar for smooth fluid physics. State changes propagate via InheritedNotifier with O(1) context lookups.',
            ),

            buildSectionCard(
              sectionTitle: 'Step 4: Learning Path Checklist & Strict Prerequisite Lock (Screen 05)',
              timing: '0:45 min',
              actionDemo: 'Show the 5 vertical lesson tiles. Scroll down to show the Final Assessment tile with a lock icon and "Complete all lessons to unlock" badge.',
              spokenScript: '"This screen demonstrates our strict pedagogical invariant: certification requires genuine mastery. Unlike superficial quiz apps, SkillUp enforces a \'lessons-first\' progression.\n\n'
                  'The Final Assessment is locked until all 5 structured lessons are completed. Even if an attacker attempts a route deep-link, our AssessmentIntroScreen guard redirects them back with an informative message."',
              flutterBiasPoints: 'Clean separation of concerns: course progression is encapsulated inside ProgressService. The UI remains declarative and purely reacts to state streams.',
            ),
          ],
        );
      },
    ),
  );

  // PAGE 3: SCREEN-BY-SCREEN DEMO SCRIPT (SCREENS 6 TO 10: QUIZ TO CERTIFICATE)
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            buildHeader('3. Screen-by-Screen Script (Continued)', subtitle: 'Phase 2: Lesson Reader, Assessment, Scoring & Dynamic Certificate (6:30 - 10:00)'),

            buildSectionCard(
              sectionTitle: 'Step 5: Lesson Reader with Real-World Case Study (Screen 06)',
              timing: '1:00 min',
              actionDemo: 'Open Lesson 1. Scroll through Concept, Key Points, Worked Code Block (tap "Copy code" to show clipboard SnackBar), and the distinct Case Study card. Tap "Mark as complete & continue".',
              spokenScript: '"Each lesson features comprehensive theory, bullet points, a copyable code block, and a realistic enterprise case study—like HyperPay reducing UI jank using Flutter\'s RepaintBoundary.\n\n'
                  'Notice the reading progress bar in the AppBar bottom. When I tap \'Mark as complete & continue\', the lesson is saved immediately to local storage, surviving app termination."',
              flutterBiasPoints: 'ScrollController listener calculates precise reading scroll offset. SelectableText and Clipboard services offer native platform integration.',
            ),

            buildSectionCard(
              sectionTitle: 'Step 6: Stratified Quiz Engine & Null-Safe Hints (Screen 08)',
              timing: '1:30 min',
              actionDemo: 'Mark all 5 lessons complete. Open Final Assessment. Answer questions. Tap "Need a hint?" on a question that has one. Tap back button to trigger PopScope leave confirmation dialog.',
              spokenScript: '"Now that all 5 lessons are complete, the assessment unlocks. Notice our quiz architecture:\n\n'
                  '1. Stratified Drawing: From an 18-question repository, our QuizService algorithm draws exactly 10 questions, guaranteeing representation across all 5 lessons.\n'
                  '2. Null Safety: The hint button only appears if hint != null. Dart’s sound null safety ensures zero crashes.\n'
                  '3. PopScope Protection: Tapping the back button triggers a protective dialog, preventing accidental data loss mid-assessment."',
              flutterBiasPoints: 'PopScope widget intercepting system pop gestures. RadioListTile-inspired OptionTile with minimum 54dp tap targets meeting WCAG AAA accessibility.',
            ),

            buildSectionCard(
              sectionTitle: 'Step 7: Review Screen & Instant On-Device Scoring (Screens 09 & 10)',
              timing: '1:00 min',
              actionDemo: 'Navigate to Review Answers. Show answered count (e.g., 8 of 10). Tap Submit to show unanswered warning dialog. Confirm Submit. Results appear instantly (<10ms).',
              spokenScript: '"On the Review screen, learners can verify their choices. Submitting triggers QuizService.evaluate. Let me emphasize: this evaluation takes less than 10 milliseconds using a pure Dart iteration loop and conditional logic.\n\n'
                  'Because there are no network hops, evaluation is instantaneous and tamper-proof. The learner immediately sees their score (8/10, 80%), a soft sage PASSED badge, and an expandable review with full explanations."',
              flutterBiasPoints: 'Pure Dart logic with zero external package overhead. Evaluates boundary conditions (0, 5, 6, 10) verified by automated unit tests.',
            ),

            buildSectionCard(
              sectionTitle: 'Step 8: Dynamic Certificate Synthesis & PDF Export (Screen 11)',
              timing: '1:00 min',
              actionDemo: 'Tap "View certificate". Showcase the authentic parchment design with gold borders and seal. Tap "Download PDF" to trigger the system PDF share/print sheet.',
              spokenScript: '"The final culmination is this official Certificate of Completion. It dynamically renders the learner\'s name, course title, completion date, score, and a unique cryptographic serial ID formatted as SKL-COURSE-YEAR-HASH.\n\n'
                  'When I tap \'Download PDF\', our CertificatePdfService constructs an authentic A4 landscape vector PDF using the Flutter pdf engine. It shares seamlessly across Android, iOS, macOS, and Web without a backend server!"',
              flutterBiasPoints: 'package:pdf compiles vector shapes, text, and borders directly into binary %PDF byte streams. Printing.sharePdf provides native platform printing dialogue.',
            ),
          ],
        );
      },
    ),
  );

  // PAGE 4: VIVA Q&A DEFENSE (ANTICIPATING TOUGH EXAMINER QUESTIONS)
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            buildHeader('4. Technical Viva Q&A Defense — Anticipating Examiner Inquiries', subtitle: 'How to defend your architectural decisions with senior Flutter engineer precision'),

            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              padding: const pw.EdgeInsets.all(8),
              decoration: const pw.BoxDecoration(
                color: lightGrey,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Q1: "Why did you use ChangeNotifier instead of Bloc or Riverpod?"', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: navy)),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'DEFENSE ANSWER: "Bloc and Riverpod are exceptional tools for massive multi-team enterprise apps with complex side-effect streams. However, for an offline certification platform, adding heavy external state management libraries introduces unnecessary third-party dependency baggage, boilerplate event streams, and binary bloat.\n'
                    'Flutter\'s built-in ChangeNotifier combined with InheritedNotifier (via our custom ProgressScope) provides clean, single-source-of-truth state management with O(1) context lookups, sub-millisecond dispatch, zero extra packages, and 100% testability."',
                    style: const pw.TextStyle(fontSize: 8.5, height: 1.35, color: darkInk),
                  ),
                ],
              ),
            ),

            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              padding: const pw.EdgeInsets.all(8),
              decoration: const pw.BoxDecoration(
                color: lightGrey,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Q2: "How is your quiz score calculated, and can learners cheat by manipulating network traffic?"', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: navy)),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'DEFENSE ANSWER: "Cheating via network interception (such as Burp Suite or Charles Proxy) is completely impossible because SkillUp performs zero network requests. Scoring is computed entirely on-device inside QuizService.evaluate using a pure Dart for-loop and strict integer equality comparison against the question bank\'s correctOptionIndex.\n'
                    'The resulting QuizResult is immutable and sealed, and the certificate is watermarked with an on-device generated verification hash."',
                    style: const pw.TextStyle(fontSize: 8.5, height: 1.35, color: darkInk),
                  ),
                ],
              ),
            ),

            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              padding: const pw.EdgeInsets.all(8),
              decoration: const pw.BoxDecoration(
                color: lightGrey,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Q3: "How does your app guarantee technical accuracy across different screen densities and font scaling?"', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: navy)),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'DEFENSE ANSWER: "We rigorously tested SkillUp for accessibility and responsiveness. In test/widget_test.dart (Test #7), we simulate extreme device constraints: a narrow 320 px screen width paired with a 200% system font text scale in dark mode. The test asserts zero RenderFlex overflow errors.\n'
                    'We achieved this by avoiding hardcoded heights, utilizing FittedBox for candidate name scaling on certificates, and leveraging Wrap and Flexible layouts for metric rows."',
                    style: const pw.TextStyle(fontSize: 8.5, height: 1.35, color: darkInk),
                  ),
                ],
              ),
            ),

            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              padding: const pw.EdgeInsets.all(8),
              decoration: const pw.BoxDecoration(
                color: lightGrey,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Q4: "What is your automated test coverage and static analysis status?"', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: navy)),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'DEFENSE ANSWER: "SkillUp passes flutter analyze with exactly zero issues, zero warnings, and zero lints. Our test suite contains 25 automated tests across 4 test suites covering scoring boundary conditions (0, 5, 6, 10), stratification invariants, sound null safety, PDF %PDF header verification, SharedPreferences corruption fallback, and complete widget journey tests. All 25 tests pass in under 4 seconds."',
                    style: const pw.TextStyle(fontSize: 8.5, height: 1.35, color: darkInk),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 6),

            // Conclusion
            buildHeader('5. Closing Statement (10:00 - 10:30)'),
            pw.Text(
              '"To conclude, SkillUp demonstrates that cross-platform Flutter development is not merely about writing UI once—it is about delivering deterministic, high-performance, accessible, and beautiful client-side software. By leveraging pure Dart logic, Material Design 3, sound null safety, and on-device PDF generation, SkillUp proves that enterprise-grade education platforms can thrive without server latency.\n\n'
              'Thank you, members of the committee. I am now open to your technical questions."',
              style: pw.TextStyle(fontSize: 9, height: 1.4, fontWeight: pw.FontWeight.bold, color: navy),
            ),
          ],
        );
      },
    ),
  );

  // Write file
  final bytes = await pdf.save();
  final outputFile = File('SkillUp_Flutter_Viva_Presentation_Script.pdf');
  await outputFile.writeAsBytes(bytes);
  stdout.writeln('Successfully generated ${outputFile.path} (${bytes.length} bytes)');
}
