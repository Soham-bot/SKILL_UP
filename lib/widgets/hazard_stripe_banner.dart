import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Industrial Diagonal Hazard Stripe Banner
/// Renders high-contrast caution stripes with bold monospace hazard text.
class HazardStripeBanner extends StatelessWidget {
  final String text;
  final Color primaryColor;
  final Color stripeColor;
  final Color textColor;
  final double height;
  final double stripeWidth;
  final double fontSize;
  final bool isRotated;
  final double rotationAngle;

  const HazardStripeBanner({
    super.key,
    required this.text,
    this.primaryColor = AppColors.neonYellow,
    this.stripeColor = AppColors.pitchBlack,
    this.textColor = AppColors.pitchBlack,
    this.height = 36.0,
    this.stripeWidth = 14.0,
    this.fontSize = 11.0,
    this.isRotated = false,
    this.rotationAngle = -0.03,
  });

  /// Factory for Success State: PASS_GRANTED // NO_CAP
  factory HazardStripeBanner.pass({
    String text = '>>> PASS_GRANTED // NO_CAP <<<',
    double height = 40.0,
  }) {
    return HazardStripeBanner(
      text: text,
      primaryColor: AppColors.acidGreen,
      stripeColor: const Color(0xFF00B344),
      textColor: AppColors.pitchBlack,
      height: height,
      fontSize: 12.0,
    );
  }

  /// Factory for Fail State: HAZARD_FAIL // RETRY_PROTOCOL
  factory HazardStripeBanner.fail({
    String text = '>>> HAZARD_FAIL // RETRY_PROTOCOL <<<',
    double height = 40.0,
  }) {
    return HazardStripeBanner(
      text: text,
      primaryColor: AppColors.glitchCrimson,
      stripeColor: const Color(0xFF990033),
      textColor: Colors.white,
      height: height,
      fontSize: 12.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget banner = Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.pitchBlack, width: 2.0),
      ),
      child: Stack(
        children: [
          // Diagonal Stripe Painter
          Positioned.fill(
            child: CustomPaint(
              painter: _HazardStripePainter(
                color1: primaryColor,
                color2: stripeColor,
                stripeWidth: stripeWidth,
              ),
            ),
          ),

          // Central High-Contrast Text Pill
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              color: AppColors.pitchBlack,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 1.2,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (isRotated) {
      return Transform.rotate(
        angle: rotationAngle,
        child: banner,
      );
    }

    return banner;
  }
}

class _HazardStripePainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final double stripeWidth;

  _HazardStripePainter({
    required this.color1,
    required this.color2,
    required this.stripeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = color1;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final stripePaint = Paint()
      ..color = color2
      ..style = PaintingStyle.fill;

    final step = stripeWidth * 2;
    for (double x = -size.height; x < size.width + size.height; x += step) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + stripeWidth, 0)
        ..lineTo(x + stripeWidth + size.height, size.height)
        ..lineTo(x + size.height, size.height)
        ..close();
      canvas.drawPath(path, stripePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HazardStripePainter oldDelegate) {
    return oldDelegate.color1 != color1 ||
        oldDelegate.color2 != color2 ||
        oldDelegate.stripeWidth != stripeWidth;
  }
}
