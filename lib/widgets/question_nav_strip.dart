import 'package:flutter/material.dart';

class QuestionNavStrip extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Map<int, int> answers;
  final ValueChanged<int> onSelectQuestion;

  const QuestionNavStrip({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.answers,
    required this.onSelectQuestion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(totalQuestions, (index) {
          final isCurrent = index == currentIndex;
          final isAnswered = answers.containsKey(index);

          Color bgColor;
          Color fgColor;
          BorderSide border;

          if (isCurrent) {
            bgColor = colorScheme.primary;
            fgColor = colorScheme.onPrimary;
            border = BorderSide(color: colorScheme.primary, width: 2);
          } else if (isAnswered) {
            bgColor = colorScheme.primaryContainer;
            fgColor = colorScheme.onPrimaryContainer;
            border = BorderSide(color: colorScheme.outline, width: 1);
          } else {
            bgColor = colorScheme.surfaceContainer;
            fgColor = colorScheme.onSurface.withOpacity(0.7);
            border = BorderSide(color: colorScheme.outline, width: 1);
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onSelectQuestion(index),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.fromBorderSide(border),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: fgColor,
                      fontWeight: isCurrent || isAnswered
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
