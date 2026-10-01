# SKILLUP — NEO-BRUTALIST & CYBER-PUNK FIGMA DESIGN SPECIFICATION

> **"Learn. Level Up. Get Certified."**  
> *Architectural Specification: Zero Padding, Asymmetric Layering, Anti-Palette & Single-Thumb Velocity Zones*  
> *Lead Designer & B.Tech Candidate: Soham Ahirrao*

---

## 1. Architectural Layout & Spatial Grid

### 1.1 Zero Padding & Edge-to-Edge Brutalism
- **Borders:** Hard 2.0px to 3.0px solid borders (`#000000` pitch black in light mode, `#FFFFFF` stark white in dark mode).
- **Corner Radii:** Strict **0px border-radius** across all components (cards, buttons, input fields, badges, and modals). Every element feels structural, hostile, and architectural.
- **Bleed & Viewports:** Eliminates polite rounded container padding; UI containers stack directly against structural dividers.

### 1.2 Asymmetric Z-Index Layering
- **Rotated Angle Tags:** Floating telemetry badges angled from `-4°` to `+7°` (`Transform.rotate(angle: -0.04)` to `0.05`).
- **Overlapping Wireframe Stickers:** High-contrast stickers (`RANK: APPRENTICE`, `// V2.0`, `100%_SYNC`) float across header boundaries, creating an intentional, raw anti-design depth hierarchy.

### 1.3 Single-Thumb Velocity Zones
- All critical user interactions (navigating syllabus nodes, picking MCQ options, triggering assessment submission, viewing credentials) are pinned to the **bottom 40% thumb-reach zone** of the mobile viewport.
- The upper 60% viewport acts as an informational data console with real-time status tickers, live telemetry monitors, and syllabus blueprints.

---

## 2. Dynamic Motion & Kinetic Physics

### 2.1 Tactile Dent Feedback (Inertia Reaction)
- Buttons and cards do not use floaty elevations or blurred drop shadows.
- Instead, SkillUp utilizes **Neo-Brutalist Hard Drop Shadows** with `blurRadius: 0` and `offset: Offset(4, 4)`.
- When the user presses glass, the button visibly **dents 3px into the canvas** (`translationValues(2.0, 2.0, 0.0)` with shadow collapsing from `4px` to `1px`), providing immediate mechanical physical feedback.

### 2.2 Glitch & Status Transitions
- Navigation between the dashboard and the assessment executes with hard status state transitions and immediate terminal verification, mimicking hardware firmware execution.

---

## 3. Typographic Hierarchy & Anti-Design Data Density

### 3.1 Monospace Terminal Typography
- Built with **Space Mono & JetBrains Mono / System Monospace** across all titles, telemetry readouts, and question prompts.
- Dense data readouts utilize ASCII syntax prefixes:
  - `>>> RUNTIME: ON_DEVICE_DART`
  - `// TRACK: MOBILE_DEV`
  - `// TIME: 45_MIN`
  - `// Q_POOL: 10_MCQS`
  - `// QUESTION [03/10]`

### 3.2 Functional Status Strings (No Plain Labels)
- Navigation and tabs replace generic polite strings with raw status codes:
  - Home ➔ `// 01_ROOT`
  - Explore ➔ `// 02_NODES`
  - My Learning ➔ `// 03_BUFFS`
  - Profile ➔ `// 04_OPERATOR`

---

## 4. Color Theory: The Anti-Palette Engine

| Semantic Name | Hex Code | Visual Identity | Functional Context |
| :--- | :--- | :--- | :--- |
| **Void Black** | `#050505` | Deep Midnight Canvas | Primary dark mode background |
| **Pitch Black** | `#000000` | True Terminal Carbon | High-contrast borders, solid shadows, dark buttons |
| **Stark White** | `#FFFFFF` | Maximum Reflectance | High-contrast dark borders, light card surface |
| **Toxic Acid Green** | `#00FF66` | Cyber Luminescence | `PASS_GRANTED // NO_CAP`, active nodes, 100% sync |
| **Hazard Yellow** | `#FFE600` | Industrial Caution | Streak cycle, XP core buffer, active execution |
| **Glitch Crimson** | `#FF0055` | Harsh Error Red | `HAZARD_FAIL // RETRY_PROTOCOL`, incomplete validation |
| **Cyber Cyan** | `#00F0FF` | Terminal Protocol Blue | Track category badges, systems architecture |
| **Concrete Off-White** | `#F4F4F0` | Unpolished Industrial Canvas| High-contrast light mode background |

---

## 5. Screen Inventory & Flow Maps

```
┌────────────────────────────────────────────────────────────────────────┐
│ 1. WelcomeScreen        │ Terminal bootloader with operator setup form │
│                         │ and 150 starter XP buffer.                   │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 2. HomeScreen           │ Anti-design hub with live status ticker,     │
│                         │ streak monitor, rotated stickers, and grid.  │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 3. ExploreScreen        │ Brutalist search terminal with hard tags and │
│                         │ fast category filter buttons.                │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 4. CourseDetailScreen   │ Industrial blueprint with 5-module list and  │
│                         │ single-thumb enrollment trigger bay.         │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 5. LearningHubScreen    │ Cyberpunk 5-module roadmap with sync counter │
│                         │ and assessment protocol unlock banner.       │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 6. LearningModuleScreen │ In-depth lesson terminal with pure-black code│
│                         │ syntax boxes and tactile advance triggers.   │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 7. QuizScreen           │ 10 random stratified MCQs, question matrix,  │
│                         │ tactile dent options, and submission modal.  │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 8. ResultScreen         │ Acid green `PASS_GRANTED // NO_CAP` banner or│
│                         │ Glitch crimson `HAZARD_FAIL` with retake.    │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 9. CertificateScreen    │ Cyber-brutalist credential with ASCII barcode│
│                         │ and cryptographic verification seal.         │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 10. MyLearningScreen    │ Monospace node buffer with Enrolled,         │
│                         │ In-Flight, and Certified tab streams.        │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 11. ProfileScreen       │ Square avatar console, telemetry metrics,    │
│                         │ theme inversion toggle, and credential book. │
└────────────────────────────────────────────────────────────────────────┘
```
