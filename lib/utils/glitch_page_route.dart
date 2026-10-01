import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Kinetic Glitch & Pixel Tear Page Route
/// Slices pixels horizontally for 140ms like a corrupted video file / signal sync error,
/// featuring horizontal displacement, RGB chromatic aberration split, and scanline jitter.
class GlitchPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  GlitchPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 140),
          reverseTransitionDuration: const Duration(milliseconds: 120),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return GlitchTearTransition(
              animation: animation,
              child: child,
            );
          },
        );

  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(context, GlitchPageRoute<T>(page: page));
  }

  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget page) {
    return Navigator.pushReplacement<T, TO>(context, GlitchPageRoute<T>(page: page));
  }
}

class GlitchTearTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const GlitchTearTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final progress = animation.value;

        // When transition completes (progress == 1.0), render clean child with 0 overhead
        if (progress >= 1.0) {
          return child;
        }

        // Kinetic tearing physics during entry (140ms)
        // High-frequency horizontal tear calculation
        final tearFactor = (1.0 - progress);
        final jitter1 = math.sin(progress * 35.0) * 16.0 * tearFactor;
        final jitter2 = math.cos(progress * 28.0) * -12.0 * tearFactor;
        final chromaticSplit = 6.0 * tearFactor;

        return Stack(
          children: [
            // Cyan Aberration Layer (Shifted Right)
            if (tearFactor > 0.1)
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(chromaticSplit + jitter2, 0),
                  child: Opacity(
                    opacity: (0.4 * tearFactor).clamp(0.0, 1.0),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF00F0FF),
                        BlendMode.screen,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),

            // Crimson Aberration Layer (Shifted Left)
            if (tearFactor > 0.1)
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(-chromaticSplit + jitter1, 0),
                  child: Opacity(
                    opacity: (0.4 * tearFactor).clamp(0.0, 1.0),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF0055),
                        BlendMode.screen,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),

            // Main Primary Content with horizontal slice displacement
            Transform.translate(
              offset: Offset(jitter1 * 0.5, 0),
              child: Opacity(
                opacity: (progress * 1.5).clamp(0.0, 1.0),
                child: child,
              ),
            ),

            // Scanline Glitch Flash Tapes
            if (tearFactor > 0.25)
              Positioned(
                top: (math.sin(progress * 10) * 200 + 300).clamp(0, 700),
                left: 0,
                right: 0,
                height: 3,
                child: Container(
                  color: const Color(0xFF00FF66).withValues(alpha: 0.8),
                ),
              ),

            if (tearFactor > 0.4)
              Positioned(
                top: (math.cos(progress * 15) * 150 + 180).clamp(0, 700),
                left: 0,
                right: 0,
                height: 2,
                child: Container(
                  color: const Color(0xFFFFE600).withValues(alpha: 0.9),
                ),
              ),
          ],
        );
      },
    );
  }
}
