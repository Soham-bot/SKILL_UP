# SkillUp — Online Skill Certification Platform

> **"A calm, professional, on-device skill certification platform engineered with Flutter & Material Design 3."**

[![Flutter](https://img.shields.io/badge/Flutter-3.47.2-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.2-0175C2?logo=dart)](https://dart.dev)
[![Material Design 3](https://img.shields.io/badge/Material_Design-3-2B3A67)](https://m3.material.io)
[![Architecture](https://img.shields.io/badge/Architecture-ChangeNotifier%20%2B%20InheritedNotifier-success)](#)
[![Scoring](https://img.shields.io/badge/Scoring-100%25%20On--Device%20%7C%20Instant-blue)](#)
[![Analysis](https://img.shields.io/badge/flutter%20analyze-0%20issues-brightgreen)](#)
[![Tests](https://img.shields.io/badge/flutter%20test-25%2F25%20passed-brightgreen)](#)

---

## 📖 1. Overview & Problem Statement

### Problem Statement
> *SkillUp wants a mobile app where learners can enroll in short skill courses, attempt topic-wise quizzes, and instantly view a pass/fail result with a certificate screen. The app should feel fast, guide the learner clearly from course selection to certificate, and calculate scores entirely on-device.*

SkillUp is rebuilt from the ground up as a **calm, dignified, distraction-free online learning and certification platform**, inspired by the aesthetic clarity and professional credibility of Coursera, Google Skillshop, LinkedIn Learning, and freeCodeCamp.

### Key Architectural Pillars
- **100% Offline & On-Device**: Zero backend servers, zero Firebase, zero external HTTP dependencies. Course catalogs, 5-lesson curriculum, 20-question randomized banks, pure Dart scoring, and PDF certificate generation operate entirely locally.
- **Material Design 3 (Quiet Royal Aesthetic)**: Fine stationery and library feel. Seeded from deep navy-indigo (`#2B3A67`), warm ivory light surface (`#FAF8F4`), deep ink dark surface (`#12151F`), muted antique gold (`#B08D57`), soft sage success (`#4F7F6A`), and muted terracotta fail/warning (`#B5654A`).
- **Pedagogical Progression**: Strict *Lessons-First* progression: all 5 comprehensive lessons (including realistic real-world case studies) must be completed before the final assessment unlocks.
- **Verifiable Dynamic Certificates**: On-screen certificate preview and A4 landscape PDF export featuring unique certificate serials (`SKL-<COURSE3>-<YYYY>-<4CHARS>`), recipient scaling, official vector seals, and share/print capabilities via `printing` and `pdf`.

---

## 🗺️ 2. The Complete User Journey

```
[Splash (1.2s)] ──► [Welcome / Name Entry] ──► [Home: Course Catalog]
                                                      │
                       ┌──────────────────────────────┘
                       ▼
               [Course Detail]
                       │ (Enroll for free)
                       ▼
               [Learning Path: 5 Lessons Checklist]
                       │ (Open lessons 1 to 5)
                       ▼
         [Lesson Reader × 5 (with Case Study & Code)]
                       │ (All 5 completed)
                       ▼
               [Assessment Intro] (10 MCQs, 60% Pass Mark, No Timer)
                       │ (Start Assessment)
                       ▼
               [Quiz × 10 Questions] (Null-safe hints, pop-scope guard)
                       │ (Review Answers)
                       ▼
               [Review & Submit] (Flags unanswered, idempotent submit)
                       │ (Submit Assessment)
                       ▼
               [Result: Score & Answer Review]
                ├── PASS (≥ 60%) ──► [Certificate] ──► Download PDF / Share
                └── FAIL (< 60%)  ──► Retake (Fresh 10 MCQs) or Review Lessons
                       │
                       ▼
        [Home Catalog]: Course marked "Completed ✓" or "Attempted"
```

---

## 📚 3. Course Catalog & Curriculum

The repository ships with **4 comprehensive, production-grade technical courses** in [`lib/data/course_repository.dart`](file:///Users/sohamahirrao/Desktop/socreate/lib/data/course_repository.dart):

| Course Title | Category | Difficulty | Lessons | Question Bank | Real-World Case Study |
|:---|:---|:---|:---:|:---:|:---|
| **Flutter Fundamentals** | Mobile | Beginner | 5 lessons (~90 min) | 20 questions | *Scale at HyperPay*: Jank reduction via RepaintBoundary and const trees |
| **Python Programming** | Programming | Beginner | 5 lessons (~95 min) | 20 questions | *DataPipe Logistics*: High-throughput streaming via Python generators & `__slots__` |
| **Web Development Basics** | Web | Beginner | 5 lessons (~80 min) | 20 questions | *NewsPulse Media*: Layout stability and Core Web Vitals optimization |
| **Cybersecurity Essentials** | Security | Intermediate | 5 lessons (~90 min) | 20 questions | *HealthVault Systems*: Zero-trust migration, bcrypt salting, and TLS 1.3 hardening |

Each lesson contains:
1. Meta header with reading duration.
2. Concept explanation (3–5 structured paragraphs).
3. Core architectural bullet points.
4. Worked syntax / code block.
5. **Real-world case study** (Scenario, Problem, Approach, Outcome, Key Takeaway).
6. Summary takeaways.

---

## 🧮 4. Pure Dart Scoring & Stratification Engine

The quiz engine is implemented cleanly in [`lib/services/quiz_service.dart`](file:///Users/sohamahirrao/Desktop/socreate/lib/services/quiz_service.dart):

### 4.1 Stratified Question Draw
To ensure rigorous educational coverage, 10 questions are drawn with **at least one question per lesson**, options shuffled, and the correct option index tracked dynamically:

```dart
static List<Question> selectQuestions(Course course, {int targetCount = 10}) {
  final Map<String, List<Question>> byLesson = {};
  for (final q in course.questionBank) {
    byLesson.putIfAbsent(q.lessonId, () => []).add(q);
  }
  // Stratified draw: at least one per lesson...
  // Options shuffled with correct index updated...
}
```

### 4.2 Score Evaluation (Pure Dart Loop + Conditionals)
```dart
static QuizResult evaluate({
  required Course course,
  required List<Question> questions,
  required Map<int, int> answers,
  required String learnerName,
}) {
  int score = 0;
  for (int i = 0; i < questions.length; i++) {              // LOOP
    final chosen = answers[i];
    if (chosen != null && chosen == questions[i].correctIndex) { // CONDITIONAL
      score++;
    }
  }
  final percentage = questions.isEmpty ? 0.0 : (score / questions.length) * 100;
  final passed = percentage >= passMark;                    // CONDITIONAL
  ...
}
```

---

## 🏗️ 5. Project Architecture & Folder Map

```
socreate/
├── lib/
│   ├── main.dart                       # Entry point, StorageService init, runApp
│   ├── app.dart                        # MaterialApp, M3 themes, onGenerateRoute
│   ├── theme/
│   │   └── app_theme.dart              # M3 light/dark ThemeData, AppStatusColors ThemeExtension
│   ├── models/
│   │   ├── course.dart                 # Course entity with lessons & 20-question bank
│   │   ├── lesson.dart                 # Lesson & CaseStudy models
│   │   ├── question.dart               # Question model with null-safe hint & explanation
│   │   ├── quiz_result.dart            # Immutable QuizResult with JSON serialization
│   │   ├── learner_profile.dart        # Name & preferences
│   │   └── enums.dart                  # Difficulty & CourseStatus enums
│   ├── data/
│   │   └── course_repository.dart      # 4 complete courses with lessons, case studies & MCQs
│   ├── services/
│   │   ├── quiz_service.dart           # Stratified selection & instant evaluation
│   │   ├── storage_service.dart        # Defensive SharedPreferences wrapper
│   │   ├── progress_service.dart       # ChangeNotifier state machine (enrollment, lessons, certs)
│   │   ├── progress_scope.dart         # InheritedNotifier provider
│   │   └── certificate_pdf_service.dart# A4 landscape PDF generator (pdf & printing)
│   ├── widgets/
│   │   ├── responsive_container.dart   # LayoutBuilder adaptive max-width container
│   │   ├── course_card.dart            # Responsive catalog card (List & Grid)
│   │   ├── status_chip.dart            # Not started / In progress / Completed status chip
│   │   ├── difficulty_tag.dart         # Difficulty pill (Beginner / Intermediate / Advanced)
│   │   ├── option_tile.dart            # Quiz option with accessible ≥48dp tap target
│   │   ├── question_nav_strip.dart     # Direct jump strip for 10 questions
│   │   ├── certificate_view.dart       # Authentic parchment certificate rendering
│   │   └── empty_state.dart            # Empty search / no learning placeholder
│   └── screens/
│       ├── splash_screen.dart          # 1.2s auto-routing splash
│       ├── welcome_screen.dart         # Validated learner name entry (2–50 chars)
│       ├── main_navigation_screen.dart # M3 NavigationBar (Home, My Learning, Profile)
│       ├── home_screen.dart            # Catalog, continue learning card, search & filters
│       ├── course_detail_screen.dart   # Outcomes, syllabus, sticky enrollment action
│       ├── learning_path_screen.dart   # 5-lesson checklist & locked/unlocked assessment
│       ├── lesson_screen.dart          # Whole concept reader, case study & progress tracker
│       ├── assessment_intro_screen.dart# Exam parameters & deep-link guard
│       ├── quiz_screen.dart            # 1-question per page, hints, PopScope leave dialog
│       ├── review_screen.dart          # Answer review & unanswered confirmation
│       ├── result_screen.dart          # Score reveal, pass/fail badge, review accordion
│       ├── certificate_screen.dart     # Full certificate view with PDF/Share/Print
│       ├── my_learning_screen.dart     # In-progress & completed courses tabs
│       └── profile_screen.dart         # Name editor, theme selector, reset progress
├── test/
│   ├── quiz_service_test.dart          # Scoring boundaries (0,5,6,10), stratification, null safety
│   ├── certificate_pdf_test.dart       # %PDF header verification & layout generation
│   ├── progress_service_test.dart      # Enrollment lifecycle, lesson unlocking, best score retention
│   └── widget_test.dart                # 8 comprehensive flow and accessibility widget tests
├── figma_tokens.json                   # W3C standard tokens export
├── FIGMA_SPEC.md                       # Frame-by-frame Figma specification (390x844 & 1280x800)
├── JUSTIFICATION.md                    # In-depth architectural & pedagogical justification
├── pubspec.yaml                        # Dependencies (shared_preferences, pdf, printing, google_fonts)
└── README.md
```

---

## 🚀 6. Setup & Running

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) $\ge 3.47.0$
- [Dart SDK](https://dart.dev) $\ge 3.13.0$
- macOS, Windows, Linux, Android Studio, or VS Code with Flutter extension.

### Setup in VS Code / Terminal
1. Clone the repository and navigate into the workspace:
   ```bash
   git clone https://github.com/Soham-bot/Skill_Up.git
   cd Skill_Up
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run static analyzer:
   ```bash
   flutter analyze
   ```
   *(Expected output: `No issues found!`)*

4. Run automated test suite:
   ```bash
   flutter test
   ```
   *(Expected output: `All 25 tests passed!`)*

5. Run on your preferred target:
   ```bash
   # Run on Chrome browser:
   flutter run -d chrome

   # Run on macOS desktop:
   flutter run -d macos

   # Run on connected iOS / Android device:
   flutter run
   ```

---

## 🧪 7. Test Suite Summary

The automated test suite in [`test/`](file:///Users/sohamahirrao/Desktop/socreate/test) covers **25 automated test cases**:

1. **`test/quiz_service_test.dart`**:
   - `0 / 10` correct evaluates to `0.0%` (failed).
   - `5 / 10` correct evaluates to `50.0%` (failed).
   - `6 / 10` boundary condition evaluates to `60.0%` (`passed: true`).
   - `10 / 10` correct evaluates to `100.0%` (`passed: true`).
   - Unanswered questions are counted incorrect.
   - Stratified selection returns exactly 10 questions with representation across all 5 lessons.
   - Option shuffling correctly keeps the right answer index synchronized.
   - Sound null safety: handles null `hint` and null `explanation` without crash or `!`.
   - Certificate ID format regex validation (`^SKL-[A-Z0-9]{3,4}-\d{4}-[A-Z0-9]{4}$`).
2. **`test/certificate_pdf_test.dart`**:
   - Generates non-empty byte buffer.
   - Asserts buffer header matches standard magic bytes `%PDF`.
3. **`test/progress_service_test.dart`**:
   - Enrollment state transitions and lesson completion logic.
   - Assessment remains locked until all 5 lessons are completed.
   - Best score preservation: retaking with lower score retains highest score on certificate.
   - Defensive fallback when `SharedPreferences` returns invalid/corrupted JSON.
   - `resetAll()` clears progress while preserving profile name.
4. **`test/widget_test.dart`**:
   - Welcome screen name validation (enables Continue only on $\ge 2$ characters).
   - Home screen displays 4 courses with responsive layout.
   - Full enrollment flow navigates to Learning Path with 5 lessons.
   - Assessment lock prevents premature access.
   - Full passing flow: Quiz $\to$ Review $\to$ Result $\to$ Certificate.
   - Passed course displays `"Completed ✓"` badge on Home catalog.
   - Responsive and accessibility pass: Dark mode builds with zero overflow at 320 px width and text scale 2.0.
   - Failing flow: Result screen displays Not Passed and Retake resets quiz state with fresh questions.

---

## 🎨 8. Design System & Tokens

SkillUp adheres strictly to **Material Design 3**:
- Zero hardcoded colors outside [`lib/theme/app_theme.dart`](file:///Users/sohamahirrao/Desktop/socreate/lib/theme/app_theme.dart).
- Full token export available in [`figma_tokens.json`](file:///Users/sohamahirrao/Desktop/socreate/figma_tokens.json).
- Comprehensive frame-by-frame Figma implementation spec in [`FIGMA_SPEC.md`](file:///Users/sohamahirrao/Desktop/socreate/FIGMA_SPEC.md).
- Academic viva documentation and design justification in [`JUSTIFICATION.md`](file:///Users/sohamahirrao/Desktop/socreate/JUSTIFICATION.md).

---

## 📄 9. License & Authorship

Developed by **Soham Ahirrao** for the **B.Tech Computer Science Engineering & AI** Cross Platform Application Capstone.
Built with 100% Flutter, Dart, and Material Design 3.
