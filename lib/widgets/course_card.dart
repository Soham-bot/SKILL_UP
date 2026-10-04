import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/enums.dart';
import 'difficulty_tag.dart';
import 'status_chip.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final CourseStatus status;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.status,
    required this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    if (category.contains('Mobile')) return Icons.phone_iphone_outlined;
    if (category.contains('Programming') || category.contains('AI')) {
      return Icons.code_outlined;
    }
    if (category.contains('Web')) return Icons.language_outlined;
    if (category.contains('Security')) return Icons.security_outlined;
    return Icons.school_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline, width: 1),
      ),
      color: colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Category Icon & Status Chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getCategoryIcon(course.category),
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  StatusChip(status: status),
                ],
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                course.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // One-line description
              Text(
                course.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.75),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Bottom Row: Difficulty & Duration (Wrapped for accessibility at 200% text scale)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        DifficultyTag(difficulty: course.difficulty),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 15,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.duration.inMinutes} min',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
