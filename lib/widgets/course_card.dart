import 'package:flutter/material.dart';
import '../models/course.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final bool isFeatured;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.isFeatured = false,
  });

  IconData _getCourseIcon(String name) {
    switch (name.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash_rounded;
      case 'python':
        return Icons.terminal_rounded;
      case 'web':
        return Icons.language_rounded;
      case 'security':
        return Icons.shield_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  Color _getCourseColor(String name) {
    switch (name.toLowerCase()) {
      case 'flutter':
        return const Color(0xFF02569B);
      case 'python':
        return const Color(0xFF3776AB);
      case 'web':
        return const Color(0xFFE44D26);
      case 'security':
        return const Color(0xFF10B981);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandColor = _getCourseColor(course.iconName);
    final percent = (course.progress * 100).toInt();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isFeatured
                ? LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E1B4B), AppColors.darkSurface]
                        : [const Color(0xFFEEF2FF), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Icon + Category & Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: brandColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: brandColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      _getCourseIcon(course.iconName),
                      color: brandColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            StatusBadge.difficulty(course.difficulty),
                            const SizedBox(width: 6),
                            if (course.status == CourseStatus.completed)
                              StatusBadge.completed()
                            else if (course.status == CourseStatus.inProgress ||
                                (course.status == CourseStatus.enrolled && course.progress > 0))
                              StatusBadge.inProgress(percent),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title and Short Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.shortDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Course Meta: Duration & 10 Assessment Questions
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 14,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '10 Assessment Questions',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        course.status == CourseStatus.completed
                            ? 'Score: ${course.bestResult?.percentage.toInt() ?? 100}%'
                            : '${course.completedModulesCount} of 5 Modules Complete',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: course.status == CourseStatus.completed
                              ? AppColors.success
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: course.progress,
                      minHeight: 6,
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        course.status == CourseStatus.completed
                            ? AppColors.success
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Bottom Action Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    course.status == CourseStatus.completed
                        ? 'CERTIFIED'
                        : course.status == CourseStatus.inProgress || course.status == CourseStatus.enrolled
                            ? 'IN PROGRESS'
                            : 'FREE ENROLLMENT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: course.status == CourseStatus.completed
                          ? AppColors.success
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        course.status == CourseStatus.completed
                            ? 'VIEW CERTIFICATE'
                            : course.status == CourseStatus.inProgress || course.status == CourseStatus.enrolled
                                ? 'CONTINUE'
                                : 'START',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: course.status == CourseStatus.completed
                              ? AppColors.success
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        course.status == CourseStatus.completed
                            ? Icons.workspace_premium_rounded
                            : Icons.arrow_forward_rounded,
                        size: 14,
                        color: course.status == CourseStatus.completed
                            ? AppColors.success
                            : AppColors.primary,
                      ),
                    ],
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
