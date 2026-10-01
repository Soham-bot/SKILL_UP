import 'package:flutter/material.dart';
import '../models/learning_module.dart';
import '../theme/app_colors.dart';

class ModuleTile extends StatelessWidget {
  final LearningModule module;
  final bool isCurrent;
  final VoidCallback onTap;

  const ModuleTile({
    super.key,
    required this.module,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color stateColor;
    IconData stateIcon;
    String statusLabel;

    if (module.isCompleted) {
      stateColor = AppColors.success;
      stateIcon = Icons.check_circle_rounded;
      statusLabel = 'Completed';
    } else if (isCurrent) {
      stateColor = AppColors.primary;
      stateIcon = Icons.arrow_circle_right_rounded;
      statusLabel = 'Continue';
    } else {
      stateColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
      stateIcon = Icons.radio_button_unchecked_rounded;
      statusLabel = 'Not Started';
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrent
                  ? AppColors.primary.withOpacity(0.5)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isCurrent ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Index Circle / Status Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: stateColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: stateColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: module.isCompleted
                      ? Icon(stateIcon, color: stateColor, size: 22)
                      : Text(
                          '${module.orderIndex}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: stateColor,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 14),

              // Title and Summary
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MODULE ${module.orderIndex}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: stateColor,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 12,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              module.estimatedMinutes,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(stateIcon, size: 14, color: stateColor),
                        const SizedBox(width: 4),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: stateColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
