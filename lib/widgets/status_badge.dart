import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool isFilled;
  final double rotation;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.isFilled = false,
    this.rotation = 0.0,
  });

  factory StatusBadge.difficulty(String difficulty) {
    Color col;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        col = AppColors.acidGreen;
        break;
      case 'intermediate':
        col = AppColors.neonYellow;
        break;
      case 'advanced':
        col = AppColors.glitchCrimson;
        break;
      default:
        col = AppColors.cyberCyan;
    }
    return StatusBadge(
      label: 'TIER: ${difficulty.toUpperCase()}',
      color: col,
      icon: Icons.bolt_rounded,
    );
  }

  factory StatusBadge.category(String category) {
    return StatusBadge(
      label: '// $category',
      color: AppColors.cyberCyan,
      icon: Icons.terminal_rounded,
    );
  }

  factory StatusBadge.completed() {
    return const StatusBadge(
      label: 'STATUS: CERTIFIED // 100%_SYNC',
      color: AppColors.acidGreen,
      icon: Icons.verified_rounded,
      isFilled: true,
      rotation: -0.03, // Asymmetric angled sticker
    );
  }

  factory StatusBadge.inProgress(int percent) {
    return StatusBadge(
      label: 'IN_FLIGHT: $percent%',
      color: AppColors.neonYellow,
      icon: Icons.sync_rounded,
      isFilled: true,
    );
  }

  factory StatusBadge.pass() {
    return const StatusBadge(
      label: 'PASS_GRANTED // NO_CAP',
      color: AppColors.acidGreen,
      icon: Icons.check_box_rounded,
      isFilled: true,
      rotation: -0.04,
    );
  }

  factory StatusBadge.fail() {
    return const StatusBadge(
      label: 'HAZARD_FAIL // RETRY_PROTOCOL',
      color: AppColors.glitchCrimson,
      icon: Icons.warning_amber_rounded,
      isFilled: true,
      rotation: 0.04,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget badgeContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isFilled ? color : (isDark ? const Color(0xFF141414) : Colors.white),
        border: Border.all(
          color: isFilled ? (isDark ? Colors.white : AppColors.pitchBlack) : color,
          width: 2.0, // Hard 2px solid brutalist border
        ),
        boxShadow: isFilled
            ? [
                BoxShadow(
                  color: isDark ? Colors.white.withValues(alpha: 0.3) : AppColors.pitchBlack,
                  offset: const Offset(2, 2),
                  blurRadius: 0, // Hard shadow
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 13,
              color: isFilled ? AppColors.pitchBlack : color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isFilled ? AppColors.pitchBlack : color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );

    if (rotation != 0.0) {
      return Transform.rotate(
        angle: rotation,
        child: badgeContent,
      );
    }
    return badgeContent;
  }
}
