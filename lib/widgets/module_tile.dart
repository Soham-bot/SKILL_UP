import 'package:flutter/material.dart';
import '../models/learning_module.dart';
import '../theme/app_colors.dart';

class ModuleTile extends StatefulWidget {
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
  State<ModuleTile> createState() => _ModuleTileState();
}

class _ModuleTileState extends State<ModuleTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color stateColor;
    String statusTag;

    if (widget.module.isCompleted) {
      stateColor = AppColors.acidGreen;
      statusTag = '[NODE_SYNCED: 100%]';
    } else if (widget.isCurrent) {
      stateColor = AppColors.neonYellow;
      statusTag = '[ACTIVE_EXECUTION]';
    } else {
      stateColor = isDark ? const Color(0xFF666666) : const Color(0xFF888888);
      statusTag = '[STANDBY_MODE]';
    }

    final shadowOffset = _isPressed ? 1.0 : 3.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        transform: Matrix4.translationValues(
          _isPressed ? 2.0 : 0.0,
          _isPressed ? 2.0 : 0.0,
          0.0,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border.all(
            color: widget.isCurrent
                ? stateColor
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: widget.isCurrent ? 2.5 : 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isCurrent
                  ? stateColor
                  : (isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.pitchBlack),
              offset: Offset(shadowOffset, shadowOffset),
              blurRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Industrial Node Box
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: widget.module.isCompleted ? AppColors.acidGreen : stateColor.withValues(alpha: 0.15),
                border: Border.all(
                  color: isDark ? Colors.white : AppColors.pitchBlack,
                  width: 2,
                ),
              ),
              child: Center(
                child: widget.module.isCompleted
                    ? const Icon(Icons.check_rounded, color: AppColors.pitchBlack, size: 22)
                    : Text(
                        '0${widget.module.orderIndex}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: isDark ? Colors.white : AppColors.pitchBlack,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        statusTag,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: stateColor,
                        ),
                      ),
                      Text(
                        '// ${widget.module.estimatedMinutes.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.module.title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.module.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDark ? Colors.white : AppColors.pitchBlack,
            ),
          ],
        ),
      ),
    );
  }
}
