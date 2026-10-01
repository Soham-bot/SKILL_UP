# SKILLUP — FIGMA DESIGN SYSTEM & PROTOTYPE SPECIFICATION

> **"Learn. Level Up. Get Certified."**  
> *Academic Capstone Project UI/UX Architecture | B.Tech CSE & AI*  
> *Designer & Author: Soham Ahirrao*

---

## 1. Design System Overview & Philosophy

The SkillUp user interface bridges high-octane gamification and modern developer aesthetics. Designed in accordance with **Google Material Design 3 (M3)** specifications, SkillUp features:
- **Spatial Grid:** 8pt incremental layout system (8px, 16px, 24px, 32px padding & margins).
- **Corner Radii:** 12px for interactive buttons & form controls, 16px for content cards, 20px for dialogs and certificates.
- **Micro-elevations:** 1px subtle border contours (`#334155` dark / `#E2E8F0` light) paired with diffused color-tinted drop shadows.
- **Dual Theming:** Sleek dark mode as the default developer theme, paired with an accessible high-contrast light mode.

---

## 2. Color Palette & Token Hierarchy

| Token Name | Hex Code | HSL Representation | Semantic Application |
| :--- | :--- | :--- | :--- |
| `primary` | `#6366F1` | `hsl(239, 84%, 67%)` | Primary brand accent, primary CTA buttons, active tab indicators |
| `primary-dark` | `#4F46E5` | `hsl(243, 75%, 59%)` | Button pressed states, light mode text emphasis |
| `secondary` | `#06B6D4` | `hsl(189, 94%, 43%)` | Category tags, system badges, code syntax highlights |
| `accent-gold` | `#F59E0B` | `hsl(38, 92%, 50%)` | XP counter, achievement badges, certificate seals & borders |
| `success-emerald`| `#10B981` | `hsl(160, 84%, 39%)` | Pass badge, 100% progress indicators, completion checks |
| `danger-rose` | `#EF4444` | `hsl(0, 84%, 60%)` | Fail badge, error states, incomplete question warnings |
| `dark-bg` | `#0A0F1D` | `hsl(224, 48%, 8%)` | Dark mode global canvas & scaffold background |
| `dark-surface` | `#121A2D` | `hsl(222, 43%, 12%)` | Dark mode card & modal containers |
| `dark-surface-elevated`| `#1E293B` | `hsl(215, 33%, 17%)`| Elevated pills, code snippet containers, chip backgrounds |
| `light-bg` | `#F8FAFC` | `hsl(210, 40%, 98%)` | Light mode canvas |
| `light-surface` | `#FFFFFF` | `hsl(0, 0%, 100%)` | Light mode cards & input containers |

---

## 3. Typography Scale (Inter Font Family)

- **Display 1 (Splash / Certificates):** 32pt • Bold (w800) • Tracking -0.5px
- **Headline 1 (Screen Titles):** 24pt • Bold (w700) • Tracking -0.2px
- **Headline 2 (Section Headers):** 18pt • SemiBold (w600)
- **Body 1 (Main Text / Lessons):** 15pt • Regular (w400) • Leading 24px (1.6)
- **Body 2 (Card Summaries):** 13pt • Regular (w400) • Leading 18px (1.4)
- **Caption / Overline (Badges, Trackers):** 10pt • Bold (w700) • Tracking 1.0px Uppercase
- **Code Snippet / Terminal:** 12.5pt JetBrains Mono / Source Code Pro • Leading 18px

---

## 4. Figma Component Library

### 1. `CourseCard` Component
- **Variants:**
  - `Layout = Grid` (Square aspect ratio 1.25)
  - `Layout = Featured` (Horizontal linear card with purple gradient highlight)
  - `Status = Available` (Displays "ENROLL & START →")
  - `Status = InProgress` (Displays percentage bar and "CONTINUE →")
  - `Status = Completed` (Displays emerald "✓ COMPLETED" badge and "VIEW CERTIFICATE →")

### 2. `ModuleTile` Component
- **States:**
  - `Completed`: Circular checkmark icon (Emerald `#10B981`), "Completed" label
  - `Current`: Indigo circular counter (`#6366F1`), bold title, "Continue" indicator
  - `Not Started`: Slate circular counter, muted text, "Not Started" label

### 3. `QuestionCard` Component
- Top header: "Question X of 10" badge, collapsible lightbulb "Hint" trigger.
- Body: 18pt prompt text.
- Option list: 4 distinct choices (`A`, `B`, `C`, `D`).
- Selected state: Indigo 2px stroke, 10% indigo surface fill, filled radio circle.

### 4. `CertificateFrame` Component
- Dual-line gold border (`#F59E0B`), embossed circular academic seal.
- Official typography hierarchy: Platform name, Certificate title, Learner Name (large uppercase), Course Title, Score badge, Date, and Unique Serial ID.

---

## 5. Screen Inventory (11 Core Screens)

```
┌────────────────────────────────────────────────────────────────────────┐
│ 1. WelcomeScreen        │ First-launch offline profile form (Name,     │
│                         │ Email, Phone) with 150 starter XP reward.    │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 2. HomeScreen           │ Gamified dashboard with streak flame, XP,    │
│                         │ continue learning, GridView, achievements.   │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 3. ExploreScreen        │ Full-text instant search bar, category chips,│
│                         │ filterable course grid.                      │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 4. CourseDetailScreen   │ Comprehensive syllabus, competencies list,   │
│                         │ duration, 5-module list, and Enroll CTA.     │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 5. LearningHubScreen    │ 5-module interactive progression roadmap with│
│                         │ dynamic progress % and assessment unlock.    │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 6. LearningModuleScreen │ In-depth lesson reader with syntax-highlight │
│                         │ code boxes, tips, and "Complete & Continue". │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 7. QuizScreen           │ 10 random stratified MCQs, question palette, │
│                         │ answer persistence, and submission dialog.   │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 8. ResultScreen         │ On-device score reveal (e.g. 8/10, 80%),     │
│                         │ conditional Pass/Fail UI branching.          │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 9. CertificateScreen    │ Verifiable academic certificate with save,   │
│                         │ share, and serial number display.            │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 10. MyLearningScreen    │ Tab-filtered courses: Enrolled, In-Progress, │
│                         │ and Completed with direct shortcuts.         │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 11. ProfileScreen       │ Learner profile editor, stats, light/dark    │
│                         │ live theme toggle, and certificates gallery. │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 6. Figma Prototype Interactive Flows

### Primary Flow: Discovery to Certification
```
[WelcomeScreen] 
   └──(Submit Profile)──> [HomeScreen] 
                            └──(Select Course)──> [CourseDetailScreen]
                                                    └──(Enroll)──> [LearningHubScreen]
                                                                     └──(Select Module 1..5)──> [LearningModuleScreen]
                                                                                                  └──(Complete 5 Modules)──> [QuizScreen]
                                                                                                                               └──(Submit 10 MCQs)──> [ResultScreen]
                                                                                                                                                        └──(Score ≥ 60%)──> [CertificateScreen]
```

### Secondary Flow A: Failed Assessment to Retake
```
[ResultScreen (Score < 60%)]
   └──(Tap "Retake Assessment")──> [QuizScreen (Flushes Old Answers, Reshuffles 10 Fresh MCQs)]
```

### Secondary Flow B: My Learning to Earned Certificate
```
[HomeScreen]
   └──(Bottom Nav: "My Learning")──> [MyLearningScreen (Tab: Completed)]
                                       └──(Tap Completed Course)──> [CertificateScreen]
```

### Secondary Flow C: Theme Customization
```
[ProfileScreen]
   └──(Toggle Appearance Switch)──> Live Rebuild across all screens from Dark to Light Theme
```
