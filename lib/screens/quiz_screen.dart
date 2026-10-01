import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/question.dart';
import '../services/course_service.dart';
import '../services/quiz_service.dart';
import '../theme/app_colors.dart';
import '../widgets/question_card.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final CourseService courseService;
  final Course course;

  const QuizScreen({
    super.key,
    required this.courseService,
    required this.course,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> _quizQuestions;
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> selectedOptionIndex
  int _currentIndex = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Generate exactly 10 stratified random questions from the course's question bank
    _quizQuestions = QuizService.generateRandomQuestions(widget.course);
  }

  void _onOptionSelected(int optionIndex) {
    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _quizQuestions.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _attemptSubmit() {
    // Academic Requirement 34: Validate that all 10 questions are answered
    if (_selectedAnswers.length < _quizQuestions.length) {
      final unansweredCount = _quizQuestions.length - _selectedAnswers.length;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded, color: AppColors.accent, size: 36),
          title: const Text('Incomplete Assessment'),
          content: Text(
            'Please answer all 10 questions before submitting.\n\nYou have $unansweredCount unanswered ${unansweredCount == 1 ? "question" : "questions"} remaining.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Back to Questions'),
            ),
          ],
        ),
      );
      return;
    }

    // Confirmation dialog before final on-device scoring
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.help_outline_rounded, color: AppColors.primary, size: 36),
        title: const Text('Submit Final Assessment?'),
        content: const Text(
          'All 10 questions have been answered. Your score will be calculated entirely on-device using Dart algorithms.\n\nAre you ready to view your result?',
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Review Answers'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _finalizeSubmission();
            },
            child: const Text('Confirm & Submit'),
          ),
        ],
      ),
    );
  }

  void _finalizeSubmission() async {
    setState(() => _isSubmitting = true);

    // On-Device Pure Dart Evaluation
    final result = QuizService.evaluateQuiz(
      course: widget.course,
      questions: _quizQuestions,
      selectedAnswers: _selectedAnswers,
    );

    // Persist result and status
    await widget.courseService.recordQuizResult(widget.course.id, result);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            courseService: widget.courseService,
            course: widget.course,
            quizResult: result,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentQ = _quizQuestions[_currentIndex];
    final selectedOption = _selectedAnswers[_currentIndex];
    final progress = (_currentIndex + 1) / _quizQuestions.length;
    final isLastQuestion = _currentIndex == _quizQuestions.length - 1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Leave Assessment?'),
            content: const Text('Your current assessment answers will not be submitted.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Leave')),
            ],
          ),
        );
        if (shouldLeave == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.course.title, style: const TextStyle(fontSize: 16)),
          actions: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_selectedAnswers.length}/10 Answered',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Previous Button
                if (_currentIndex > 0) ...[
                  OutlinedButton.icon(
                    onPressed: _previousQuestion,
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text('Previous'),
                  ),
                  const SizedBox(width: 12),
                ],

                // Next or Submit Button
                Expanded(
                  child: FilledButton.icon(
                    onPressed: isLastQuestion ? _attemptSubmit : _nextQuestion,
                    style: FilledButton.styleFrom(
                      backgroundColor: isLastQuestion ? AppColors.success : AppColors.primary,
                    ),
                    icon: Icon(
                      isLastQuestion ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                    label: Text(isLastQuestion ? 'Submit Assessment' : 'Next Question'),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _isSubmitting
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Calculating score on-device...',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ASSESSMENT PROGRESS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                        Text(
                          '${_currentIndex + 1} / ${_quizQuestions.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick Question Index Bar (1 to 10 clickable pills)
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _quizQuestions.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, idx) {
                          final isAnswered = _selectedAnswers.containsKey(idx);
                          final isCur = idx == _currentIndex;

                          Color bgColor;
                          Color textColor;
                          if (isCur) {
                            bgColor = AppColors.primary;
                            textColor = Colors.white;
                          } else if (isAnswered) {
                            bgColor = AppColors.success.withOpacity(0.2);
                            textColor = AppColors.success;
                          } else {
                            bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
                            textColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
                          }

                          return InkWell(
                            onTap: () => setState(() => _currentIndex = idx),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isCur
                                      ? AppColors.primary
                                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${idx + 1}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Question Card Component
                    QuestionCard(
                      question: currentQ,
                      questionNumber: _currentIndex + 1,
                      totalQuestions: _quizQuestions.length,
                      selectedOptionIndex: selectedOption,
                      onSelectOption: _onOptionSelected,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
