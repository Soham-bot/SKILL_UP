# SKILLUP — VIVA MENTOR DEFENSE MANUAL & DEMO SCRIPT

> **"Learn. Level Up. Get Certified."**  
> *B.Tech Computer Science Engineering & AI Final Capstone Project*  
> *Candidate & Author: Soham Ahirrao*

---

## 1. Requirement Traceability Matrix (RTM)

This matrix maps every official academic requirement directly to its implementation files and empirical demo evidence.

| Official Requirement | Implementation Description | Primary Code File(s) | Demonstration Evidence |
| :--- | :--- | :--- | :--- |
| **Short Skill Courses** | 4 complete courses (Flutter, Python, Web Dev, Cybersecurity) with metadata, competencies, and durations. | `lib/data/course_data.dart`<br>`lib/models/course.dart` | Course cards on Home and Explore screens showing categories and duration. |
| **Course Listing** | Responsive discovery via horizontal list and adaptive GridView. | `lib/screens/home_screen.dart`<br>`lib/screens/explore_screen.dart` | Adaptive GridView rendering 1-column on mobile and 2-column on desktop. |
| **Course Detail Overview** | Full course syllabus, competencies checklist, duration, modules count. | `lib/screens/course_detail_screen.dart` | "What You Will Learn" checklist and 5-module preview list. |
| **Enroll in Courses** | Local state machine managing lifecycle: Available $\to$ Enrolled $\to$ In Progress $\to$ Completed. | `lib/services/course_service.dart`<br>`lib/models/course.dart` | Clicking "ENROLL & START LEARNING" unlocks course in Learning Hub and awards +25 XP. |
| **Topic-Wise Learning Hub** | Exactly five learning modules per course with visual roadmap. | `lib/screens/learning_hub_screen.dart`<br>`lib/widgets/module_tile.dart` | Numbered roadmap showing status: Completed (✓), Continue (→), Not Started (○). |
| **Rich Learning Content** | Modular educational sections with code syntax blocks, tips, and key takeaways. | `lib/screens/learning_module_screen.dart`<br>`lib/models/learning_module.dart` | In-depth theory, formatted code boxes, bullet points, and key takeaway cards. |
| **Module Completion Flow** | Progressive completion with progress bar update and automatic advance. | `lib/screens/learning_module_screen.dart`<br>`lib/services/course_service.dart` | Clicking "COMPLETE & CONTINUE" marks module complete, increments progress by 20%, advances to next module. |
| **Course Completion Prompt** | Completion banner unlocking assessment after all 5 modules are complete. | `lib/screens/learning_hub_screen.dart` | "🎉 COURSE CONTENT COMPLETE" banner unlocks "TAKE FINAL ASSESSMENT". |
| **10 Random MCQs** | Stratified stochastic selection of 10 questions across all 5 modules from an 18-question pool. | `lib/services/quiz_service.dart` | QuizScreen draws exactly 10 questions covering all 5 modules; reshuffles on retake. |
| **On-Device Scoring** | Pure Dart loop and equality comparison with zero server calls. | `lib/services/quiz_service.dart` | Score evaluated in < 1ms on device; zero network latency or dependencies. |
| **Pass / Fail Logic** | Strict evaluation against `static const double passPercentage = 60.0`. | `lib/services/quiz_service.dart`<br>`lib/screens/result_screen.dart` | Score $\ge 60\%$ branches to Pass (view certificate); $< 60\%$ branches to Fail (review & retake). |
| **Dynamic Certificate** | Verifiable credential with Name, Course, Score, Date, and Unique Serial ID. | `lib/widgets/certificate_widget.dart`<br>`lib/screens/certificate_screen.dart` | Displays learner name, score percentage, date issued, and ID (e.g. `SKL-FLT-2026-8942`). |
| **Completed Course State** | Status permanently updated to Completed; best score recorded. | `lib/models/course.dart`<br>`lib/services/course_service.dart` | Green "✓ COMPLETED" badge on Home and My Learning tabs. |
| **Retake Workflow** | Flushes previous answers, generates fresh 10 MCQs, resets score. | `lib/screens/quiz_screen.dart`<br>`lib/screens/result_screen.dart` | Tapping "Retake" creates a fresh attempt without app restart. |
| **Material Design 3 & Themes**| Full M3 theming with dynamic dark and light mode toggle. | `lib/theme/app_theme.dart`<br>`lib/theme/app_colors.dart` | Dynamic switch in Profile and AppBar instantly switches themes across all screens. |
| **Sound Null Safety** | Real nullable properties (`String? hint`, `String? explanation`) with safe fallback. | `lib/models/question.dart`<br>`lib/widgets/question_card.dart` | Null hints safely omit hint toggle; null explanations handled without runtime errors. |
| **Offline-First Persistence** | SharedPreferences storing profile, progress, results, and theme. | `lib/services/storage_service.dart` | App state fully preserved across cold restarts without internet access. |

---

## 2. 5-Minute Live Demonstration Walkthrough Script

| Time | Demonstration Step | Actions to Perform on Screen | Examiner Talking Points |
| :---: | :--- | :--- | :--- |
| **0:00 – 0:30** | **App Cold Launch & Profile Setup** | Launch app. Show WelcomeScreen. Enter "Soham Ahirrao" and submit. | *"Good morning, respected examiners. SkillUp is an offline-first, gamified learning and certification platform built using Flutter and Material 3. On initial launch, it creates a local learner profile without requiring complex or slow server authentication."* |
| **0:30 – 1:00** | **Gamified Dashboard Exploration** | Show HomeScreen: Streak (🔥), XP (⚡), Status pills, and Course cards. Toggle Dark/Light mode. | *"The Home screen functions as an energetic learning dashboard. We track active streaks, accumulate XP, and surface in-progress courses. Notice the seamless transition between our custom dark and light Material 3 design systems."* |
| **1:00 – 1:45** | **Course Discovery & Enrollment** | Open Explore tab. Filter by "Mobile Development". Tap "Flutter Fundamentals". Click "ENROLL & START LEARNING". | *"SkillUp features 4 complete curriculum tracks. Clicking 'Enroll' activates a local lifecycle transition from Available to Enrolled, immediately unlocking the 5-module Learning Hub and awarding 25 XP."* |
| **1:45 – 2:45** | **Topic-Wise Learning Hub & Module Reader** | Show 5-module roadmap. Open Module 1. Scroll through concepts and syntax code box. Click "COMPLETE & CONTINUE". | *"Each course has exactly five rich learning modules. Content is structured into digestible cards with syntax code snippets, tips, and key takeaways. Notice our progress bar advances in 20% increments as modules are completed."* |
| **2:45 – 3:30** | **Unlocking Assessment & Random 10 MCQs** | Complete all 5 modules. Show "🎉 COURSE CONTENT COMPLETE" banner. Click "TAKE FINAL ASSESSMENT". | *"Completing all five modules unlocks the final assessment. Our question bank contains 18 technical questions. SkillUp's stratified random algorithm selects exactly 10 questions ensuring every module is tested."* |
| **3:30 – 4:15** | **Answering MCQs & On-Device Scoring** | Answer all 10 questions. Show question navigator and hint toggle. Click Submit. Confirm in dialog. | *"Notice answer persistence as we navigate back and forth, and submission validation preventing premature submission. Clicking submit triggers our pure Dart scoring algorithm entirely on-device with zero API latency."* |
| **4:15 – 4:45** | **Result & Dynamic Certificate Generation** | Show ResultScreen (8/10, 80%, PASS). Click "VIEW CERTIFICATE". | *"Because our score exceeds the academic 60% threshold, the learner passes. We generate a verifiable certificate with the learner's name, course title, score, date, and a unique algorithmic serial ID."* |
| **4:45 – 5:00** | **Completed State & Retake Demonstration** | Return to Home. Show "✓ COMPLETED" badge. Show retake flow. | *"Returning to Home shows the course marked as Completed. If a learner retakes the exam, a fresh set of 10 questions is generated. This completes the entire user journey."* |

---

## 3. High-Scoring Viva Q&A Cheat Sheet

### Q1: "Why did you not use a backend like Firebase or Node.js?"
> **Authoritative Viva Answer:**  
> *"Because the official academic problem statement specifically requires on-device score calculation and fast, offline-first execution. Incorporating an unnecessary remote backend would introduce network latency, authentication friction, and failure points. By implementing course data, progress tracking, and scoring locally in Dart with SharedPreferences, SkillUp runs with sub-second performance, ensures complete user privacy, and directly demonstrates core Flutter and Dart competencies."*

### Q2: "How does your random question selection algorithm work?"
> **Authoritative Viva Answer:**  
> *"A naive random shuffle of the entire 18-question bank could accidentally draw all 10 questions from only one or two modules. To ensure pedagogical fairness, SkillUp uses **stratified random sampling**: questions are grouped into five buckets by their `moduleId`. The algorithm guarantees at least 1–2 questions are drawn from each module bucket before pooling the remaining questions to fill exactly 10 questions. Finally, the selected 10 questions are shuffled so question order is randomized."*

### Q3: "How is score calculated on-device?"
> **Authoritative Viva Answer:**  
> *"In `QuizService.evaluateQuiz()`, we iterate through the 10 selected questions using a standard loop. For each index, we compare the learner's selected option index against the question's `correctOptionIndex`. If equal, the score integer increments. We compute the percentage as `(score / totalQuestions) * 100` and evaluate against the constant `static const double passPercentage = 60.0`. An immutable `QuizResult` object is then returned."*

### Q4: "How is Sound Null Safety demonstrated in your Dart code?"
> **Authoritative Viva Answer:**  
> *"In our `Question` model, `hint` and `explanation` are explicitly declared as nullable (`String? hint`, `String? explanation`), while `questionText` and `options` are non-nullable. In `QuestionCard`, we safely check `if (widget.question.hint != null)` before rendering the hint button, ensuring that questions without hints do not cause null pointer exceptions or render empty widgets."*

### Q5: "Why did you choose ChangeNotifier over complex state management like Bloc or Redux?"
> **Authoritative Viva Answer:**  
> *"For an application of this scope, over-engineering with complex state boilerplate introduces unnecessary cognitive overhead. `ChangeNotifier` combined with `AnimatedBuilder` provides a clean, observable pattern that separates business logic (`CourseService`) from presentation while remaining easily maintainable, performant, and simple to defend during academic viva."*

### Q6: "What is the difference between Hot Reload and Hot Restart in Flutter?"
> **Authoritative Viva Answer:**  
> *"Hot Reload injects updated source code into the running Dart Virtual Machine, immediately updating widget build methods while preserving application state (e.g. current quiz answers). Hot Restart destroys the existing state, re-executes `main()`, and resets the app from scratch in a fraction of a second."*
