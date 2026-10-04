# How to Import & Submit Your Figma Flow (2-Minute Guide)

This folder contains **100% native Figma-ready vector artboards** for the 4 core screens:
1. `01_home_screen.svg` (`390 × 844 px`)
2. `02_course_detail_screen.svg` (`390 × 844 px`)
3. `03_quiz_screen.svg` (`390 × 844 px`)
4. `04_certificate_screen.svg` (`390 × 844 px`)
5. `00_complete_figma_flow.svg` (`1820 × 960 px` master flow with arrows and annotations)

---

## ⚡ Method 1: Instant Drag & Drop into Figma (Recommended)

1. Open [Figma](https://figma.com) in your browser or desktop app and click **"New design file"**.
2. Open your file manager (`Finder` on Mac or `Explorer` on Windows) and navigate to:
   ```
   socreate/figma_export/
   ```
3. Drag and drop **`00_complete_figma_flow.svg`** directly onto the Figma canvas.
   - **Result**: Figma instantly imports all 4 screens side by side with the connection noodles, exact $390 \times 844\text{ px}$ dimensions, rounded corners, and editable text/vector layers!
4. *(Optional)* Alternatively, drag the 4 individual files (`01_home_screen.svg`, `02_course_detail_screen.svg`, etc.) to arrange them as independent top-level Frames.

---

## 🔗 Method 2: Adding Interactive Prototype Connections in Figma

To present this as a clickable interactive prototype in Figma:
1. Select the **Prototype** tab on the top-right toolbar of Figma (or press `Shift + E`).
2. **Connection 1 (Home $\to$ Detail)**:
   - Click the first course card on **01_Home** (*Flutter Fundamentals*).
   - Drag the blue circle noodle $\to$ connect it to the **02_CourseDetail** frame.
   - Interaction: `On click` $\to$ `Navigate to` $\to$ `Instant` or `Smart Animate (300ms ease-out)`.
3. **Connection 2 (Detail $\to$ Quiz)**:
   - Click the *"Enroll for free"* bottom button on **02_CourseDetail**.
   - Drag the blue circle noodle $\to$ connect it to the **03_Quiz** frame.
   - Interaction: `On click` $\to$ `Navigate to`.
4. **Connection 3 (Quiz $\to$ Certificate)**:
   - Click the *"Next Question / Submit"* button on **03_Quiz**.
   - Drag the blue circle noodle $\to$ connect it to the **04_Certificate** frame.
   - Interaction: `On click` $\to$ `Navigate to`.
5. Press the **Play (▷)** button in the top right corner of Figma to preview the live prototype!

---

## 📤 Method 3: Submitting Your Figma Deliverable

When submitting for your project review or evaluation:
- **Option A (Figma Share Link)**:
  - In Figma, click the blue **Share** button in the top right.
  - Set permissions to *"Anyone with the link can view"*.
  - Copy and paste the link into your project submission form.
- **Option B (Export .fig File)**:
  - Click the Figma menu icon (top left) $\to$ **File** $\to$ **Save local copy...**
  - Save the `.fig` file to your computer.

---

## 🎨 Design Tokens & Styles Used

- **Seed & Primary**: `#2B3A67` (Deep Navy)
- **Accent / Tertiary**: `#B08D57` (Muted Antique Gold)
- **Surfaces**: `#FAF8F4` (Warm Ivory paper) / `#FFFFFF` (Cards)
- **Outlines**: `#E4E0D8` (1px subtle border)
- **Success Role**: `#4F7F6A` (Soft Sage)
- **Warning Role**: `#B5654A` (Muted Terracotta)
- **Typography Scale**: Fraunces (Headings, 600 weight) + Inter (Body & Labels, 400/500/600)
- Full W3C JSON tokens are also saved in [`figma_tokens.json`](../figma_tokens.json).
