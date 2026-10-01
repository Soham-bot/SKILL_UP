import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool isFilled;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.isFilled = false,
  });

  factory StatusBadge.difficulty(String difficulty) {
    Color col;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        col = AppColors.success;
        break;
      case 'intermediate':
        col = AppColors.accent;
        break;
      case 'advanced':
        col = AppColors.danger;
        break;
      default:
        col = AppColors.primary;
    }
    return StatusBadge(
      label: difficulty,
      color: col,
      icon: Icons.speed_rounded,
    );
  }

  factory StatusBadge.category(String category) {
    return StatusBadge(
      label: category,
      color: AppColors.secondary,
      icon: Icons.layers_outlined,
    );
  }

  factory StatusBadge.completed() {
    return const StatusBadge(
      label: 'COMPLETED',
      color: AppColors.success,
      icon: Icons.check_circle_rounded,
      isFilled: true,
    );
  }

  factory StatusBadge.inProgress(int percent) {
    return StatusBadge(
      label: '$percent% IN PROGRESS',
      color: AppColors.primary,
      icon: Icons.trending_up_rounded,
    );
  }

  factory StatusBadge.pass() {
    return const StatusBadge(
      label: 'PASSED',
      color: AppColors.success,
      icon: Icons.verified_rounded,
      isFilled: true,
    );
  }

  factory StatusBadge.fail() {
    return const StatusBadge(
      label: 'NOT PASSED',
      color: AppColors.danger,
      icon: Icons.cancel_rounded,
      isFilled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isFilled ? color : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFilled ? Colors.transparent : color.withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 13,
              color: isFilled ? Colors.white : color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isFilled ? Colors.white : color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
