import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Wireframe Grid & Spatial Architecture Background
/// Renders raw structural grid lines, intersection crosshairs (+),
/// edge ruler notch ticks, and hex coordinates directly onto the canvas.
class WireframeGridBackground extends StatelessWidget {
  final Widget child;
  final bool showRuler;
  final bool showCoordinates;

  const WireframeGridBackground({
    super.key,
    required this.child,
    this.showRuler = true,
    this.showCoordinates = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomPaint(
      painter: _WireframeGridPainter(
        isDark: isDark,
        showRuler: showRuler,
        showCoordinates: showCoordinates,
      ),
      child: child,
    );
  }
}

class _WireframeGridPainter extends CustomPainter {
  final bool isDark;
  final bool showRuler;
  final bool showCoordinates;

  _WireframeGridPainter({
    required this.isDark,
    required this.showRuler,
    required this.showCoordinates,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = isDark
          ? const Color(0xFFFFFFFF).withValues(alpha: 0.04)
          : const Color(0xFF000000).withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    final crosshairPaint = Paint()
      ..color = isDark
          ? AppColors.acidGreen.withValues(alpha: 0.22)
          : const Color(0xFF000000).withValues(alpha: 0.18)
      ..strokeWidth = 1.2;

    const gridSize = 48.0;

    // Draw structural vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw structural horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw Crosshairs (+) at key grid intersections
    for (double x = gridSize; x < size.width; x += gridSize * 3) {
      for (double y = gridSize; y < size.height; y += gridSize * 4) {
        const arm = 4.0;
        canvas.drawLine(Offset(x - arm, y), Offset(x + arm, y), crosshairPaint);
        canvas.drawLine(Offset(x, y - arm), Offset(x, y + arm), crosshairPaint);
      }
    }

    // Draw Ruler Notches on top and left bezels
    if (showRuler) {
      final rulerPaint = Paint()
        ..color = isDark
            ? AppColors.acidGreen.withValues(alpha: 0.35)
            : const Color(0xFF000000).withValues(alpha: 0.25)
        ..strokeWidth = 1.5;

      for (double x = 0; x < size.width; x += 16.0) {
        final height = (x % 48 == 0) ? 6.0 : 3.0;
        canvas.drawLine(Offset(x, 0), Offset(x, height), rulerPaint);
      }

      for (double y = 0; y < size.height; y += 16.0) {
        final width = (y % 48 == 0) ? 6.0 : 3.0;
        canvas.drawLine(Offset(0, y), Offset(width, y), rulerPaint);
      }
    }

    // Draw Corner Structural Coordinate Stamp
    if (showCoordinates) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'GRID: [0x00_SYS // 0xFF_RAW]',
          style: TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            color: isDark
                ? AppColors.acidGreen.withValues(alpha: 0.25)
                : const Color(0xFF000000).withValues(alpha: 0.2),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.width - textPainter.width - 6, 8));
    }
  }

  @override
  bool shouldRepaint(covariant _WireframeGridPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
