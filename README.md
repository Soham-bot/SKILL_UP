# SKILLUP — Gamified Offline Learning & Certification Platform

> **"Learn. Level Up. Get Certified."**

[![Flutter](https://img.shields.io/badge/Flutter-3.47.2-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.2-0175C2?logo=dart)](https://dart.dev)
[![Material Design 3](https://img.shields.io/badge/Material_Design-3-6366F1)](https://m3.material.io)
[![Platform](https://img.shields.io/badge/Platform-Cross--Platform%20(iOS%20%7C%20Android%20%7C%20macOS%20%7C%20Web)-blue)](#)
[![Status](https://img.shields.io/badge/Status-100%25%20Offline%20First-success)](#)
[![License](https://img.shields.io/badge/License-Academic%20Capstone-emerald)](#)

---

## 📖 Executive Summary & Academic Problem Statement

### Academic Problem Statement
> *"SkillUp wants a mobile app where learners can enroll in short skill courses, attempt topic-wise quizzes, and instantly view a pass/fail result with a certificate screen. The app should feel fast, guide the learner clearly from course selection to certificate, and calculate scores entirely on-device."*

**SkillUp** is a miniature, gamified, offline-first cross-platform learning platform engineered with Flutter and Dart. Designed specifically as a final **Cross Platform Application Capstone Project** for **B.Tech Computer Science Engineering and Artificial Intelligence**, SkillUp proves that rich, interactive, and pedagogically sound educational software can operate with zero external API dependencies, sub-second latency, and uncompromising design aesthetics.

---

## 🎯 Objectives & Key Features

1. **Course Discovery & Free Enrollment:**
   - Browse technical skill domains (Mobile Development, Programming & AI, Web Engineering, Systems Security).
   - Local state machine manages course lifecycle: `Available` $\to$ `Enrolled` $\to$ `In Progress` $\to$ `Completed`.
2. **Topic-Wise Five-Module Learning Hub:**
   - Every course contains **exactly five structured learning modules**.
   - Modular lessons broken into Theory, Core Concepts, Syntax/Architecture code blocks, Pro-Tips, and Key Takeaways.
   - Interactive progress bar dynamically updates as modules are completed.
3. **Randomized Assessment Engine (Stratified 10 MCQs):**
   - Each course maintains a repository of 15–20 questions across all five modules.
   - When launching an assessment, the system dynamically selects **exactly 10 questions**, ensuring stratified representation across all five topics.
   - Repeated attempts reshuffle both question selection and order.
4. **On-Device Pure Dart Scoring Logic:**
   - 100% offline, zero network calls. Scores are computed using pure Dart iteration, equality comparison, and percentage evaluation.
   - Academic constant: `passPercentage = 60.0`.
5. **Dynamic Verifiable Certificate Generation:**
   - Passing learners ($\ge 60\%$) receive an official certificate featuring their name, course title, score, percentage, timestamp, and unique serial identifier (`SKL-XXX-YYYY-ZZZZ`).
6. **Gamification & Micro-Interactions:**
   - Visual learning streak tracker (🔥), XP progression (⚡), achievement badges (🏆), and instant feedback.
7. **Sound Null Safety & Material 3:**
   - Full support for light and dark modes with Material 3 theming.
   - Rigorous Dart sound null safety demonstration (`hint?`, `explanation?`) with graceful UI fallback.

---

## 🗺️ Core User Journey

```
┌─────────────────┐
│   App Launch    │
└────────┬────────┘
         ▼
┌─────────────────────────────────┐
│ Welcome / Learner Profile Setup │ ◄── Name, Email, Phone (Saved Locally)
└────────┬────────────────────────┘
         ▼
┌─────────────────────────────────┐
│     Home / Gamified Hub         │ ◄── Streak, XP, Continue Learning, GridView
└────────┬────────────────────────┘
         ▼
┌─────────────────────────────────┐
│       Course Overview           │ ◄── Syllabus, Outcomes, Skills Learned
└────────┬────────────────────────┘
         ▼
┌─────────────────────────────────┐
│  [ Enroll & Start Learning ]    │ ◄── Lifecycle: Available ➔ Enrolled
└────────┬────────────────────────┘
         ▼
┌─────────────────────────────────┐
│      Course Learning Hub        │ ◄── 5 Topic-Wise Modules Roadmap
└────────┬────────────────────────┘
         ▼
┌─────────────────────────────────┐
│  Interactive Module Reader      │ ◄── Read Concepts, Review Code Examples
└────────┬────────────────────────┘
         ▼
┌─────────────────────────────────┐
│  Complete All 5 Modules         │ ◄── Unlocks Final Assessment
└────────┬────────────────────────┘
         ▼
┌─────────────────────────────────┐
│ 10-Question Random MCQ Exam     │ ◄── Stratified draw from 18-question bank
└────────┬────────────────────────┘
         ▼
┌─────────────────────────────────┐
│   Instant On-Device Evaluation  │ ◄── Score calculated locally in Dart
└────────┬────────────────────────┘
         ├──[ Score < 60% : Fail ]──────┐
         ▼                              ▼
┌──────────────────────────┐    ┌───────────────────────────┐
│   Official Certificate   │    │  Review Modules & Retake  │
│  (Passed ≥ 60%, Unique ID)│   │  (Generates Fresh 10 MCQs) │
└──────────────────────────┘    └───────────────────────────┘
```

---

## 📚 Curriculum & Course Catalog

| Course Title | Category | Difficulty | Modules | Question Bank | Focus Skills |
| :--- | :--- | :--- | :---: | :---: | :--- |
| **Flutter Fundamentals** | Mobile Development | Beginner | 5 | 18 MCQs | Engine Architecture, Dart Null Safety, Widget Tree, State & setState, pubspec.yaml |
| **Python Programming** | Programming & AI | Beginner | 5 | 18 MCQs | CPython Execution, Sequences & Dicts, Functions & Closures, OOP & Duck Typing, Context Managers |
| **Web Development Basics**| Web Engineering | Beginner | 5 | 18 MCQs | Semantic HTML5, CSS Grid & Flexbox, Event Loop, Promises & async/await, Fetch API & JSON |
| **Cybersecurity Fundamentals** | Security & Systems | Intermediate | 5 | 18 MCQs | CIA Triad, TLS 1.3 & Firewalls, AES vs RSA, Hashing & Salting, OWASP Top 10, Zero Trust |

---

## 🧮 Assessment & On-Device Scoring Architecture

### Stratified 10-Question Selection
```dart
List<Question> generateRandomQuestions(Course course) {
  // 1. Group 18-question pool into 5 module buckets
  final Map<String, List<Question>> buckets = {};
  for (final q in course.questionBank) {
    buckets.putIfAbsent(q.moduleId, () => []).add(q);
  }

  // 2. Stratified guarantee: Draw at least 1 question per module
  final List<Question> selected = [];
  for (final entry in buckets.entries) {
    final shuffled = List<Question>.from(entry.value)..shuffle();
    if (shuffled.isNotEmpty) selected.add(shuffled.removeLast());
  }

  // 3. Pool remaining questions, shuffle, and fill up to exactly 10
  final List<Question> remaining = [];
  for (final q in course.questionBank) {
    if (!selected.contains(q)) remaining.add(q);
  }
  remaining.shuffle();
  while (selected.length < 10 && remaining.isNotEmpty) {
    selected.add(remaining.removeLast());
  }

  return selected..shuffle();
}
```

### On-Device Score Calculation Algorithm
```dart
static const double passPercentage = 60.0;

QuizResult evaluateQuiz({
  required Course course,
  required List<Question> questions,
  required Map<int, int> selectedAnswers,
}) {
  int score = 0;
  for (int i = 0; i < questions.length; i++) {
    if (selectedAnswers[i] == questions[i].correctOptionIndex) {
      score++;
    }
  }
  final double percentage = (score / questions.length) * 100.0;
  final bool passed = percentage >= passPercentage;

  return QuizResult(
    courseId: course.id,
    courseTitle: course.title,
    score: score,
    totalQuestions: questions.length,
    percentage: percentage,
    passed: passed,
    attemptedAt: DateTime.now(),
    certificateId: CertificateUtils.generateCertificateId(course.id),
  );
}
```

---

## 🏗️ Technical Architecture & Folder Structure

```
skillup/
├── lib/
│   ├── main.dart                       # App bootstrap & dynamic theme listening
│   ├── models/
│   │   ├── course.dart                 # Course entity, status machine & progress logic
│   │   ├── learning_module.dart        # 5 modules per course with structured sections
│   │   ├── question.dart               # MCQ model with sound null-safe hint/explanation
│   │   ├── quiz_result.dart            # Immutable result with score and certificate ID
│   │   └── learner_profile.dart        # Local profile (name, XP, streak)
│   ├── data/
│   │   └── course_data.dart            # 4 courses, 20 educational modules, 72 MCQs
│   ├── services/
│   │   ├── storage_service.dart        # SharedPreferences persistence
│   │   ├── quiz_service.dart           # Stratified selection & on-device score calculation
│   │   └── course_service.dart         # ChangeNotifier state management
│   ├── theme/
│   │   ├── app_colors.dart             # Curated developer tech palette
│   │   └── app_theme.dart              # Material 3 light and dark theme configurations
│   ├── widgets/
│   │   ├── course_card.dart            # Course display card (Grid & List)
│   │   ├── module_tile.dart            # Learning Hub roadmap module item
│   │   ├── question_card.dart          # 4-option radio selector with hint toggle
│   │   ├── stat_card.dart              # Gamified streak & XP metrics
│   │   ├── status_badge.dart           # Category, difficulty & pass/fail badges
│   │   └── certificate_widget.dart     # Verifiable certificate card with gold seal
│   ├── screens/
│   │   ├── welcome_screen.dart         # Initial learner profile setup
│   │   ├── main_navigation_screen.dart # Persistent 4-tab bottom navigation
│   │   ├── home_screen.dart            # Gamified dashboard (Streak, XP, Discovery)
│   │   ├── explore_screen.dart         # Filterable search & category chips
│   │   ├── course_detail_screen.dart   # Syllabus, outcomes, and enrollment
│   │   ├── learning_hub_screen.dart    # 5-module progression roadmap
│   │   ├── learning_module_screen.dart # Interactive lesson reader with code examples
│   │   ├── quiz_screen.dart            # 10 random MCQs, progress bar & validator
│   │   ├── result_screen.dart          # Instant score reveal & pass/fail feedback
│   │   ├── certificate_screen.dart     # Verifiable certificate screen
│   │   ├── my_learning_screen.dart     # Enrolled, In-Progress & Completed tabs
│   │   └── profile_screen.dart         # Learner stats, theme switcher & certificates
│   └── utils/
│       └── certificate_utils.dart      # Unique ID generator (e.g. SKL-FLT-2026-8942)
├── test/
│   ├── quiz_service_test.dart          # Unit tests: 10 MCQs, stratification, scoring, null safety
│   ├── course_progress_test.dart       # Unit tests: 5 modules, progression, state machine
│   └── widget_test.dart                # Widget test: launch, branding & welcome flow
├── pubspec.yaml
└── README.md
```

---

## 🎨 Design System & Theming

SkillUp implements **Material Design 3** with dual-mode support:
- **Primary Color:** Electric Indigo (`#6366F1`)
- **Secondary Color:** Cyber Cyan (`#06B6D4`)
- **Gamified XP Accent:** Vibrant Amber (`#F59E0B`)
- **Pass Status:** Emerald Green (`#10B981`)
- **Fail Status:** Crimson Rose (`#EF4444`)
- **Surfaces:** Dark Slate (`#0A0F1D` / `#121A2D`) & Light Slate (`#F8FAFC` / `#FFFFFF`)
- **Typography:** Google Fonts Inter with system sans-serif fallback

---

## 🧪 Testing & Verification

SkillUp includes an automated test suite verifying all core academic invariants:

```bash
flutter test
```

### Automated Test Output
```
00:00 +0: Course Progression & State Machine Tests TC06, TC08 & TC09: Module completion updates progress and state machine
00:00 +1: Course Progression & State Machine Tests All 4 courses have exactly 5 modules and >= 15 questions
00:00 +2: Quiz Engine & Scoring Logic TC10 & TC11: Course contains > 10 questions, but generated quiz has exactly 10
00:00 +3: Quiz Engine & Scoring Logic TC11 Stratification: Questions cover all 5 learning modules
00:00 +4: Quiz Engine & Scoring Logic TC11 Randomization: Repeat attempts produce varied shuffles
00:00 +5: Quiz Engine & Scoring Logic TC15 & TC16: On-Device Score Calculation and Passing Threshold (60%)
00:00 +6: Quiz Engine & Scoring Logic TC23 & TC24: Sound Null Safety handling for hint and explanation
00:00 +7: TC01 & TC02: SkillUp launches and displays branding and setup/home flow
00:00 +8: All tests passed!
```

---

## 🚀 Installation & Running

### Prerequisites
- Flutter SDK $\ge 3.47.0$
- Dart SDK $\ge 3.13.0$

### Steps
1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd socreate
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run on your desired target:
   ```bash
   # Run on connected phone / desktop / Chrome:
   flutter run

   # Or build standalone Web bundle:
   flutter build web --release
   ```

---

## 📦 Academic & Design Deliverables Bundle

All non-runtime submission artifacts, formal reports, Figma assets, and testing matrices have been consolidated into [`academic_deliverables/`](./academic_deliverables/) and packaged into a single submission archive:
* **Single Submission Archive:** [`SkillUp_Academic_Deliverables.zip`](./SkillUp_Academic_Deliverables.zip) (741 KB)
* **Manifest & Evaluation Guide:** [`academic_deliverables/DELIVERABLES_MANIFEST.md`](./academic_deliverables/DELIVERABLES_MANIFEST.md)
* **Full Academic Report (38 Chapters):** [`academic_deliverables/SkillUp_Academic_Project_Report.docx`](./academic_deliverables/SkillUp_Academic_Project_Report.docx)
* **Figma Neo-Brutalist Design System:** [`academic_deliverables/FIGMA_DESIGN_SYSTEM.md`](./academic_deliverables/FIGMA_DESIGN_SYSTEM.md)
* **Figma Vector Artboards:** [`academic_deliverables/figma_assets/`](./academic_deliverables/figma_assets/)
* **Formal QA Test Report (TC01–TC25):** [`academic_deliverables/TEST_REPORT.md`](./academic_deliverables/TEST_REPORT.md)
* **Viva Voce Defense & Demo Script:** [`academic_deliverables/VIVA_GUIDE.md`](./academic_deliverables/VIVA_GUIDE.md)

---

## 👨‍💻 Author

**Soham Ahirrao**  
*B.Tech in Computer Science Engineering & Artificial Intelligence*  
Cross Platform Application Capstone Project
