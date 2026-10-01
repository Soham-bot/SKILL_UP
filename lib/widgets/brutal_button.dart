import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Tactile Neo-Brutalist Button
/// Physically dents into the screen when pressed down (translating 3.5px
/// diagonally and collapsing the 0-blur drop shadow).
class BrutalButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color? shadowColor;
  final double borderWidth;
  final double shadowOffset;
  final EdgeInsetsGeometry padding;
  final Widget? leading;
  final Widget? trailing;
  final bool isFullWidth;
  final double fontSize;

  const BrutalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.shadowColor,
    this.borderWidth = 2.5,
    this.shadowOffset = 4.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.leading,
    this.trailing,
    this.isFullWidth = true,
    this.fontSize = 13.0,
  });

  @override
  State<BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<BrutalButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = widget.onPressed == null;

    final bg = widget.backgroundColor ??
        (isDark ? AppColors.acidGreen : AppColors.pitchBlack);
    final fg = widget.foregroundColor ??
        (isDark ? AppColors.pitchBlack : AppColors.acidGreen);
    final border = widget.borderColor ??
        (isDark ? Colors.white : AppColors.pitchBlack);
    final shadow = widget.shadowColor ??
        (isDark ? Colors.white : AppColors.pitchBlack);

    final currentOffset = _isPressed ? 1.0 : widget.shadowOffset;
    final translation = _isPressed ? (widget.shadowOffset - 1.0) : 0.0;

    Widget buttonContent = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.leading != null) ...[
          widget.leading!,
          const SizedBox(width: 8),
        ],
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            letterSpacing: 0.8,
            color: isDisabled ? fg.withValues(alpha: 0.5) : fg,
          ),
        ),
        if (widget.trailing != null) ...[
          const SizedBox(width: 8),
          widget.trailing!,
        ],
      ],
    );

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        transform: Matrix4.translationValues(translation, translation, 0.0),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: isDisabled ? bg.withValues(alpha: 0.4) : bg,
          border: Border.all(
            color: isDisabled ? border.withValues(alpha: 0.4) : border,
            width: widget.borderWidth,
          ),
          boxShadow: _isPressed || isDisabled
              ? null
              : [
                  BoxShadow(
                    color: shadow,
                    offset: Offset(currentOffset, currentOffset),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: buttonContent,
      ),
    );
  }
}
