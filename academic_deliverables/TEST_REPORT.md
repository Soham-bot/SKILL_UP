# SKILLUP — FORMAL QA TEST REPORT (25 TEST CASES)

> **"Learn. Level Up. Get Certified."**  
> *Academic Capstone Project Quality Assurance Matrix*  
> *Author & Lead QA: Soham Ahirrao*

---

## 1. Test Execution Summary

- **Total Test Cases:** 25
- **Tests Passed:** 25
- **Tests Failed:** 0
- **Pass Rate:** 100.0%
- **Execution Environment:** macOS Darwin ARM64, Chrome Web, Flutter 3.47.2, Dart 3.13.2

---

## 2. Test Execution Matrix (TC01 – TC25)

| Test ID | Test Scenario | Execution Steps | Expected Result | Actual Result | Status |
| :---: | :--- | :--- | :--- | :--- | :---: |
| **TC01** | App Launch & Initialization | Launch application binary from cold boot. | Splash initializes, loads local storage, displays Welcome or Home. | Successfully initialized offline with zero network calls. | **PASS** |
| **TC02** | Profile Creation | Enter name "Soham Ahirrao", optional email/phone, click Continue. | Profile saved in SharedPreferences; user awarded +150 XP. | Name persisted; navigated to MainNavigationScreen. | **PASS** |
| **TC03** | Home Screen Rendering | Observe dashboard UI elements after launch. | Displays greeting, streak flame, XP counter, Continue card, and GridView. | All gamified elements, cards, and bottom navigation render correctly. | **PASS** |
| **TC04** | Course Browsing | Navigate to Explore tab; test search and category chips. | Courses filter instantaneously as search text or chips change. | Filtered instantly; verified with Mobile, Python, Web, and Security. | **PASS** |
| **TC05** | Course Detail Inspection | Tap on "Flutter Fundamentals" card. | Displays overview, duration (45 min), 5 modules, 10 MCQs, and skills list. | All metadata, syllabus items, and enrollment buttons rendered. | **PASS** |
| **TC06** | Course Enrollment | Click "ENROLL & START LEARNING" on an available course. | Course status transitions from `available` to `enrolled`; +25 XP awarded. | Status updated; user transitioned to Learning Hub. | **PASS** |
| **TC07** | Module Navigation | In Learning Hub, tap Module 1 tile. | Opens LearningModuleScreen for Module 1 with estimated time. | Loaded Module 1 content, overview, and code examples. | **PASS** |
| **TC08** | Module Completion | Click "COMPLETE & CONTINUE →" on Module 1. | Module 1 marked completed; progress updates to 20%; advances to Module 2. | Checked in state; awarded +30 XP; opened Module 2. | **PASS** |
| **TC09** | Progress Calculation | Mark modules 1 through 5 as complete sequentially. | Progress calculates accurately: 20%, 40%, 60%, 80%, 100%. | Math verified via `completedModulesCount / 5.0`; 100% unlocks exam. | **PASS** |
| **TC10** | Quiz Generation | Click "TAKE FINAL ASSESSMENT" after 5 modules are complete. | Assessment engine activates; draws questions from the 18-question pool. | Generated exactly 10 questions for the assessment. | **PASS** |
| **TC11** | Stratified Random Selection | Inspect module IDs of the 10 selected questions. | Questions are drawn across all 5 modules (stratified sampling). | Verified: every module from 1 to 5 has representation. | **PASS** |
| **TC12** | Answer Selection | Select option 'C' for Question 1. | Option highlights with indigo border, filled radio, and background tint. | Option stored in `_selectedAnswers[0] = 2`; state updated. | **PASS** |
| **TC13** | Previous & Next Navigation | Click Next to Question 2, select answer, then click Previous to Question 1. | Navigates between questions; previous selection on Question 1 is retained. | Answer persistence verified; no loss of selected state. | **PASS** |
| **TC14** | Submission Validation | Attempt to submit with only 8 of 10 questions answered. | Submitting is blocked; alert modal: "Please answer all 10 questions". | Alert displayed; prevented premature submission without crashing. | **PASS** |
| **TC15** | On-Device Scoring | Answer all 10 questions (8 correct, 2 incorrect); submit assessment. | On-device loop calculates score = 8, percentage = 80.0%. | Calculated in < 1ms via pure Dart with zero API latency. | **PASS** |
| **TC16** | Passing Threshold Evaluation | Verify ResultScreen output for 80% score ($\ge 60\%$). | ResultScreen displays "ASSESSMENT COMPLETE 🎉", "YOU PASSED", and View Certificate. | Passing branch triggered; course marked Completed; +150 XP. | **PASS** |
| **TC17** | Failing Threshold Evaluation | Submit quiz with 4 correct answers (40% score, $< 60\%$). | ResultScreen displays "NOT PASSED (< 60%)", Review Course, and Retake button. | Failing branch triggered; course status not marked completed. | **PASS** |
| **TC18** | Dynamic Certificate Generation | Tap "VIEW CERTIFICATE" on passing result. | Displays official Certificate of Completion with Name, Course, Score, Date, and ID. | Name "SOHAM AHIRRAO", score "8/10 (80%)", ID "SKL-FLT-2026-XXXX". | **PASS** |
| **TC19** | Course Completed Status | Return to Home screen after passing. | Course displays emerald "✓ COMPLETED" badge and best score. | Status displayed on Home and My Learning tabs. | **PASS** |
| **TC20** | Retake Workflow | On ResultScreen (or Learning Hub), tap "Retake Assessment". | Clears answers, generates fresh stratified 10 MCQs, resets index to 0. | Reshuffled question set generated cleanly without restarting app. | **PASS** |
| **TC21** | Theme Switching | Toggle theme switch in Profile or AppBar. | App dynamically switches between Dark and Light mode across all screens. | Rebuilt immediately with seamless transition. | **PASS** |
| **TC22** | Responsive Layout | Test on narrow mobile screen (360px) and wide desktop (> 600px). | Layout adapts; GridView switches from 1 column to 2 columns; no overflows. | Verified zero render overflows across viewports. | **PASS** |
| **TC23** | Null Hint Safety | Navigate to question with `hint == null` (e.g. `flt_q03`). | UI renders without crashing; "Hint" toggle button is safely hidden. | Handled gracefully via `if (question.hint != null)`. | **PASS** |
| **TC24** | Null Explanation Safety | Inspect question with `explanation == null` (e.g. `flt_q04`). | No null dereference errors during evaluation or model serialization. | Sound null safety verified; null values handled without error. | **PASS** |
| **TC25** | Offline Self-Sufficiency | Disconnect internet / run in airplane mode. | App retains 100% of capabilities: browse, enroll, read, quiz, and certify. | Zero network requests initiated; 100% offline verified. | **PASS** |

---

## 3. Automated Test Suite Execution Output

```
$ flutter test
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
