import 'package:flutter/material.dart';
import '../models/enums.dart';

class DifficultyTag extends StatelessWidget {
  final Difficulty difficulty;

  const DifficultyTag({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 0.8,
        ),
      ),
      child: Text(
        difficulty.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
