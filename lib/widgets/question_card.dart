import 'package:flutter/material.dart';
import '../models/question.dart';
import '../theme/app_colors.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final int questionNumber;
  final int totalQuestions;
  final int? selectedOptionIndex;
  final ValueChanged<int> onSelectOption;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.selectedOptionIndex,
    required this.onSelectOption,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool _showHint = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const optionLetters = ['A', 'B', 'C', 'D'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Header Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                offset: const Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: isDark ? Colors.white : AppColors.pitchBlack,
                    child: Text(
                      '// QUESTION [${widget.questionNumber.toString().padLeft(2, '0')}/${widget.totalQuestions.toString().padLeft(2, '0')}]',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: isDark ? AppColors.pitchBlack : AppColors.acidGreen,
                      ),
                    ),
                  ),

                  // Sound Null Safety: Only render if hint != null
                  if (widget.question.hint != null)
                    GestureDetector(
                      onTap: () => setState(() => _showHint = !_showHint),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.neonYellow,
                          border: Border.all(color: AppColors.pitchBlack, width: 1.5),
                        ),
                        child: Text(
                          _showHint ? '[HIDE_DEBUG_HINT]' : '[VIEW_HINT]',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: AppColors.pitchBlack,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 14),

              // Question Prompt Text
              Text(
                widget.question.questionText,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  height: 1.4,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),

              // Sound Null Safety: Hint Body
              if (_showHint && widget.question.hint != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1A00) : const Color(0xFFFFFBEB),
                    border: Border.all(color: AppColors.neonYellow, width: 2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '// DEBUG: ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: AppColors.neonYellow,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.question.hint!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Action Zone Header
        Text(
          '// SELECT_SINGLE_OPTION_MATRIX:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            letterSpacing: 0.8,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 10),

        // 4 Tactile Option Selectors
        ...List.generate(widget.question.options.length, (index) {
          final isSelected = widget.selectedOptionIndex == index;
          final letter = index < optionLetters.length ? optionLetters[index] : '${index + 1}';
          final optionText = widget.question.options[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => widget.onSelectOption(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 70),
                transform: Matrix4.translationValues(
                  isSelected ? 2.0 : 0.0,
                  isSelected ? 2.0 : 0.0,
                  0.0,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.acidGreen : AppColors.pitchBlack)
                      : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.acidGreen)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: isSelected ? 2.5 : 2.0,
                  ),
                  boxShadow: isSelected
                      ? null
                      : [
                          BoxShadow(
                            color: isDark ? Colors.white.withValues(alpha: 0.25) : AppColors.pitchBlack,
                            offset: const Offset(3, 3),
                            blurRadius: 0,
                          ),
                        ],
                ),
                child: Row(
                  children: [
                    // Letter Tag Box
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.pitchBlack : AppColors.acidGreen)
                            : (isDark ? const Color(0xFF222222) : const Color(0xFFEEEEEE)),
                        border: Border.all(
                          color: isSelected ? (isDark ? Colors.white : AppColors.pitchBlack) : (isDark ? Colors.white : AppColors.pitchBlack),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: isSelected
                                ? (isDark ? AppColors.acidGreen : AppColors.pitchBlack)
                                : (isDark ? Colors.white : AppColors.pitchBlack),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Option Text
                    Expanded(
                      child: Text(
                        optionText,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                          fontFamily: 'monospace',
                          color: isSelected
                              ? (isDark ? AppColors.pitchBlack : Colors.white)
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Active Check indicator
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        color: isDark ? AppColors.pitchBlack : AppColors.acidGreen,
                        child: Text(
                          'SELECTED',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
