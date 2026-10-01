# SKILLUP — NEO-BRUTALIST & CYBER-PUNK FIGMA DESIGN SPECIFICATION

> **"Learn. Level Up. Get Certified."**  
> *Architectural Specification: Zero Padding, Asymmetric Layering, Anti-Palette & Single-Thumb Velocity Zones*  
> *Lead Designer & B.Tech Candidate: Soham Ahirrao*

---

## 1. Visual Showcase & High-Fidelity Figma Render

A high-resolution design system showcase rendering the Figma canvas with all 3 core archetype screens (Dashboard/Feed, MCQ Challenge with single-thumb velocity zone, and Verified Flex Certificate with caution tape & ASCII QR verification) is generated and stored locally in the repository:

- **Local Preview File:** [`figma_showcase.jpg`](file:///Users/sohamahirrao/Desktop/socreate/figma_showcase.jpg)
- **Design Tokens JSON (Importable):** [`figma_tokens.json`](file:///Users/sohamahirrao/Desktop/socreate/figma_tokens.json)

---

## 2. Architectural Layout & Spatial Grid

### 2.1 Zero Padding & Edge-to-Edge Brutalism
- **Frame Preset:** iPhone 15 Pro (`393 × 852 px`) or Standard Mobile (`375 × 812 px`).
- **Borders & Strokes:** Hard 2.0px to 3.0px solid borders (`#000000` pitch black in light mode, `#FFFFFF` stark white in dark mode).
- **Corner Radii:** Strict **0px border-radius** across all components (cards, buttons, input fields, badges, and modals). Every element feels structural, hostile, and architectural.
- **Bleed & Viewports:** Eliminates polite rounded container padding; UI containers stack directly against structural dividers.

### 2.2 Asymmetric Z-Index Layering
- **Rotated Angle Tags:** Floating telemetry badges angled from `-4°` to `+7°` (`Transform.rotate(angle: -0.04)` to `0.05`).
- **Overlapping Wireframe Stickers:** High-contrast stickers (`RANK: GOAT IN TRAINING 🔥`, `// V2.0 // NO CAP`, `PASS_GRANTED // NO_CAP`) float across header boundaries, creating an intentional, raw anti-design depth hierarchy.

### 2.3 Single-Thumb Velocity Zones
- All critical user interactions (navigating syllabus nodes, picking MCQ options, triggering assessment submission, viewing credentials) are pinned to the **bottom 40% thumb-reach zone** of the mobile viewport.
- The upper 60% viewport acts as an informational data console with real-time status tickers, live telemetry monitors, and syllabus blueprints.

---

## 3. Dynamic Motion & Kinetic Physics

### 3.1 Tactile Dent Feedback (Inertia Reaction)
- Buttons and cards do not use floaty elevations or blurred drop shadows.
- Instead, SkillUp utilizes **Neo-Brutalist Hard Drop Shadows** with `blurRadius: 0` and `offset: Offset(4, 4)`.
- When the user presses glass, the button visibly **dents 3.5px into the canvas** (`translationValues(3.5, 3.5, 0.0)` with shadow collapsing from `4px` to `0px`), providing immediate mechanical physical feedback.

### 3.2 Glitch & Horizontal Pixel Tear Transitions
- Page transitions execute with a **140ms horizontal slice tear** and chromatic RGB aberration (cyan right, magenta left) mimicking hardware firmware execution.

---

## 4. Typographic Hierarchy & Anti-Design Data Density

### 4.1 Monospace Terminal Typography
- Built with **Space Mono & JetBrains Mono / System Monospace** across all titles, telemetry readouts, and question prompts.
- Dense data readouts utilize ASCII syntax prefixes:
  - `>>> RUNTIME: ON_DEVICE_DART`
  - `// TRACK: MOBILE_DEV`
  - `// GRIND TIME: 45 MIN`
  - `// FINAL BOSS: 10 MCQS`
  - `// QUESTION [03/10]`

### 4.2 Functional Status Strings (No Plain Labels)
- Navigation and tabs replace generic polite strings with raw status codes:
  - Home ➔ `// 01_FEED`
  - Explore ➔ `// 02_DROPS`
  - My Learning ➔ `// FLEX_RECEIPT`
  - Profile ➔ `// AURA_STATS`

---

## 5. Color Theory: The Anti-Palette Engine

| Semantic Name | Hex Code | Visual Identity | Functional Context |
| :--- | :--- | :--- | :--- |
| **Void Black** | `#050505` | Deep Midnight Canvas | Primary dark mode background |
| **Pitch Black** | `#000000` | True Terminal Carbon | High-contrast borders, solid shadows, dark buttons |
| **Stark White** | `#FFFFFF` | Maximum Reflectance | High-contrast dark borders, light card surface |
| **Toxic Acid Green** | `#00FF66` | Cyber Luminescence | `PASS_GRANTED // NO_CAP`, active nodes, 100% sync |
| **Hazard Yellow** | `#FFE600` | Industrial Caution | Streak cycle, Aura points core buffer, active execution |
| **Glitch Crimson** | `#FF0055` | Harsh Error Red | `HAZARD_FAIL // RETRY_PROTOCOL`, brain lag pulse |
| **Cyber Cyan** | `#00F0FF` | Terminal Protocol Blue | Track category badges, systems architecture |
| **Blood Orange** | `#550C00` | Ambient Latency Glow | Anti-palette cognitive latency pulse when operator stalls |
| **Concrete Off-White** | `#F4F4F0` | Industrial Canvas | High-contrast light mode background |

---

## 6. How to Import Tokens & Present in Figma

### 6.1 One-Click Figma Import via Tokens Studio
1. Open [Figma](https://www.figma.com/) and create a new design file named **SkillUp Design System**.
2. Install / Open the **Tokens Studio for Figma** plugin (or Figma's native **Variables** panel).
3. Click **Settings ➔ Import JSON** and select [`figma_tokens.json`](file:///Users/sohamahirrao/Desktop/socreate/figma_tokens.json).
4. All color styles (`acidGreen`, `voidBlack`, `hazardYellow`), stroke widths (`2.5px`), and 0-blur drop shadows will populate automatically into your Figma file styles.

### 6.2 Adding the Visual Showcase to Your Canvas
- Drag and drop [`figma_showcase.jpg`](file:///Users/sohamahirrao/Desktop/socreate/figma_showcase.jpg) directly into your Figma canvas as a reference artboard or portfolio mockup!

---

## 7. Screen Inventory & Flow Maps

```
┌────────────────────────────────────────────────────────────────────────┐
│ 1. WelcomeScreen        │ Terminal bootloader with operator setup form │
│                         │ (Drop your lore, Gamer tag, 150 start Aura). │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 2. HomeScreen           │ Anti-design hub with live status ticker,     │
│                         │ daily streak, aura points, and drops grid.   │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 3. ExploreScreen        │ Brutalist search terminal with hard tags and │
│                         │ category filter buttons (4 track drops).     │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 4. CourseDetailScreen   │ Industrial blueprint with 5-module list and  │
│                         │ single-thumb enrollment trigger bay.         │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 5. LearningHubScreen    │ Cyberpunk 5-module roadmap with sync counter │
│                         │ and final boss assessment unlock banner.     │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 6. LearningModuleScreen │ In-depth lesson terminal with pure-black code│
│                         │ syntax boxes and tactile advance triggers.   │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 7. QuizScreen           │ 10 random stratified MCQs, question matrix,  │
│                         │ anti-palette brain lag watchdog, tactile dent│
├─────────────────────────┼──────────────────────────────────────────────┤
│ 8. ResultScreen         │ Acid green `PASS_GRANTED // NO_CAP` banner or│
│                         │ Glitch crimson `TOTAL L // COOKED` + retake. │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 9. CertificateScreen    │ Cyber-brutalist credential with ASCII barcode│
│                         │ and cryptographic verification seal.         │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 10. MyLearningScreen    │ Monospace node buffer with Enrolled,         │
│                         │ Cooking, and Certified W's tab streams.      │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 11. ProfileScreen       │ Square avatar console, telemetry metrics,    │
│                         │ theme inversion toggle, and certified ledger.│
└────────────────────────────────────────────────────────────────────────┘
```

---

## 8. What to Say in Your Viva Defense About Figma

When your examiner asks: **"Did you design this in Figma before coding?"**

> *"Yes! We designed the entire application following a strict **Neo-Brutalist & Anti-Design Design System** in Figma. We created a formal Design Token Architecture defined in `figma_tokens.json` which governs our color palette (Void Black `#050505`, Toxic Acid Green `#00FF66`, Hazard Yellow `#FFE600`), our strict 0px border-radius, hard 2.5px solid strokes, and 0-blur mechanical drop shadows. Every screen adheres to a single-thumb velocity zone on an iPhone 15 Pro grid (`393 × 852 px`), mapping 1-to-1 to our Flutter widget tree."*
