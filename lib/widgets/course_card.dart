import 'package:flutter/material.dart';
import '../models/course.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final VoidCallback onTap;
  final bool isFeatured;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.isFeatured = false,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isPressed = false;

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
        return Icons.code_rounded;
    }
  }

  Color _getCourseColor(String name) {
    switch (name.toLowerCase()) {
      case 'flutter':
        return AppColors.cyberCyan;
      case 'python':
        return AppColors.neonYellow;
      case 'web':
        return const Color(0xFFFF5500);
      case 'security':
        return AppColors.acidGreen;
      default:
        return AppColors.electricViolet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandColor = _getCourseColor(widget.course.iconName);
    final percent = (widget.course.progress * 100).toInt();

    // Neo-Brutalist Tactile Dent: on press, offset decreases from 4px to 1px
    final shadowOffset = _isPressed ? 1.0 : 4.0;
    final shadowColor = isDark
        ? (widget.course.status == CourseStatus.completed ? AppColors.acidGreen : brandColor)
        : AppColors.pitchBlack;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        margin: const EdgeInsets.only(bottom: 12),
        transform: Matrix4.translationValues(
          _isPressed ? 3.0 : 0.0,
          _isPressed ? 3.0 : 0.0,
          0.0,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 2.5, // 2.5px brutalist solid border
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(shadowOffset, shadowOffset),
              blurRadius: 0, // Solid zero-blur drop shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Bar: Track Code + Status Stickers
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: brandColor,
                        border: Border.all(
                          color: isDark ? Colors.white : AppColors.pitchBlack,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _getCourseIcon(widget.course.iconName),
                        color: AppColors.pitchBlack,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '// TRACK: ${widget.course.category.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: brandColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        StatusBadge.difficulty(widget.course.difficulty),
                      ],
                    ),
                  ],
                ),

                // Asymmetric Top Right Badge
                if (widget.course.status == CourseStatus.completed)
                  StatusBadge.completed()
                else if (widget.course.status == CourseStatus.inProgress ||
                    (widget.course.status == CourseStatus.enrolled && widget.course.progress > 0))
                  StatusBadge.inProgress(percent),
              ],
            ),

            const SizedBox(height: 12),

            // Course Title & Description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.course.title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    fontFamily: 'monospace',
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.course.shortDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Monospace Telemetry: Duration & Question Pool
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: isDark ? const Color(0xFF181818) : const Color(0xFFEBEBE5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '// TIME: ${widget.course.duration.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  Text(
                    '// Q_POOL: 10_MCQS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Hard 2px Linear Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.course.status == CourseStatus.completed
                          ? 'SCORE: ${widget.course.bestResult?.percentage.toInt() ?? 100}% // PASSED'
                          : '[SYNC: ${widget.course.completedModulesCount}/5 MODULES]',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: widget.course.status == CourseStatus.completed
                            ? AppColors.acidGreen
                            : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: widget.course.status == CourseStatus.completed
                            ? AppColors.acidGreen
                            : (isDark ? Colors.white : AppColors.pitchBlack),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF222222) : const Color(0xFFDDDDDD),
                    border: Border.all(
                      color: isDark ? Colors.white : AppColors.pitchBlack,
                      width: 1.5,
                    ),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: widget.course.progress.clamp(0.0, 1.0),
                    child: Container(
                      color: widget.course.status == CourseStatus.completed
                          ? AppColors.acidGreen
                          : brandColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Single-Thumb Brutalist Action Bay
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: widget.course.status == CourseStatus.completed
                    ? AppColors.acidGreen
                    : (isDark ? Colors.white : AppColors.pitchBlack),
                border: Border.all(
                  color: isDark ? Colors.white : AppColors.pitchBlack,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  widget.course.status == CourseStatus.completed
                      ? '>>> VIEW_CREDENTIAL >>>'
                      : widget.course.status == CourseStatus.inProgress ||
                              widget.course.status == CourseStatus.enrolled
                          ? '>>> RESUME_NODE >>>'
                          : '>>> INITIALIZE_ENROLLMENT >>>',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontFamily: 'monospace',
                    color: widget.course.status == CourseStatus.completed
                        ? AppColors.pitchBlack
                        : (isDark ? AppColors.pitchBlack : AppColors.acidGreen),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
