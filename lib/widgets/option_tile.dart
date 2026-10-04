import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.index,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  String get _letter {
    const letters = ['A', 'B', 'C', 'D'];
    if (index >= 0 && index < letters.length) return letters[index];
    return '${index + 1}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final borderColor = isSelected ? colorScheme.primary : colorScheme.outline;
    final borderWidth = isSelected ? 1.8 : 1.0;
    final bgColor = isSelected
        ? colorScheme.primaryContainer.withOpacity(0.35)
        : colorScheme.surfaceContainer;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: borderWidth),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Option Letter Badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? colorScheme.primary : colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _letter,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Option Text
                Expanded(
                  child: Text(
                    text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),

                // Radio Indicator
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.4),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
