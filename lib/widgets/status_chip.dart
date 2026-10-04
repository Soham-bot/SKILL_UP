import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  final CourseStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColors = theme.extension<AppStatusColors>() ?? AppStatusColors.light;

    Color bgColor;
    Color fgColor;
    IconData? icon;

    switch (status) {
      case CourseStatus.completed:
        bgColor = colorScheme.tertiaryContainer;
        fgColor = colorScheme.onTertiaryContainer;
        icon = Icons.check_circle_outline;
        break;
      case CourseStatus.attempted:
        bgColor = statusColors.warningContainer;
        fgColor = statusColors.onWarningContainer;
        icon = Icons.refresh;
        break;
      case CourseStatus.inProgress:
        bgColor = colorScheme.primaryContainer;
        fgColor = colorScheme.onPrimaryContainer;
        icon = Icons.timelapse;
        break;
      case CourseStatus.notStarted:
        bgColor = colorScheme.surfaceContainerHigh;
        fgColor = colorScheme.onSurfaceVariant;
        icon = null;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.5),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fgColor),
            const SizedBox(width: 4),
          ],
          Text(
            status.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
