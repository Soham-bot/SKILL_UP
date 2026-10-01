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
  final Map<int, int> _selectedAnswers = {};
  int _currentIndex = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
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
    if (_selectedAnswers.length < _quizQuestions.length) {
      final unansweredCount = _quizQuestions.length - _selectedAnswers.length;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: AppColors.pitchBlack,
          title: const Text(
            'INCOMPLETE EVALUATION MATRIX',
            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, color: AppColors.glitchCrimson),
          ),
          content: Text(
            'Please answer all 10 questions before submitting.\n\n$unansweredCount question(s) remain unanswered.',
            style: const TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 12),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              style: FilledButton.styleFrom(backgroundColor: AppColors.glitchCrimson),
              child: const Text('BACK_TO_QUESTIONS'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: AppColors.pitchBlack,
        title: const Text(
          'SUBMIT ASSESSMENT PROTOCOL?',
          style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, color: AppColors.acidGreen),
        ),
        content: const Text(
          'All 10 questions have been logged. Scoring will execute immediately on-device using Dart arithmetic.\n\nProceed to final evaluation?',
          style: TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('// REVIEW_LOGS', style: TextStyle(fontFamily: 'monospace')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _finalizeSubmission();
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.acidGreen, foregroundColor: AppColors.pitchBlack),
            child: const Text('CONFIRM_SUBMIT'),
          ),
        ],
      ),
    );
  }

  void _finalizeSubmission() async {
    setState(() => _isSubmitting = true);

    final result = QuizService.evaluateQuiz(
      course: widget.course,
      questions: _quizQuestions,
      selectedAnswers: _selectedAnswers,
    );

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
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: AppColors.pitchBlack,
            title: const Text(
              'ABORT ASSESSMENT?',
              style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, color: AppColors.glitchCrimson),
            ),
            content: const Text(
              'Unsubmitted answers will be purged from active memory.',
              style: TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 12),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('RESUME')),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: FilledButton.styleFrom(backgroundColor: AppColors.glitchCrimson),
                child: const Text('ABORT'),
              ),
            ],
          ),
        );
        if (shouldLeave == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('// ${widget.course.title.toUpperCase()} // EXAM'),
          actions: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: isDark ? const Color(0xFF222222) : const Color(0xFFE5E5DE),
                child: Text(
                  '${_selectedAnswers.length}/10 ANSWERED',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: AppColors.acidGreen,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.white : AppColors.pitchBlack,
                width: 2.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                if (_currentIndex > 0) ...[
                  OutlinedButton(
                    onPressed: _previousQuestion,
                    child: const Text('< PREV'),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: FilledButton(
                    onPressed: isLastQuestion ? _attemptSubmit : _nextQuestion,
                    style: FilledButton.styleFrom(
                      backgroundColor: isLastQuestion ? AppColors.acidGreen : (isDark ? Colors.white : AppColors.pitchBlack),
                      foregroundColor: isLastQuestion ? AppColors.pitchBlack : (isDark ? AppColors.pitchBlack : AppColors.acidGreen),
                    ),
                    child: Text(
                      isLastQuestion ? '>>> SUBMIT_EVALUATION >>>' : 'NEXT_QUESTION >',
                    ),
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
                    CircularProgressIndicator(color: AppColors.acidGreen),
                    SizedBox(height: 16),
                    Text(
                      'COMPUTING SCORE ON-DEVICE...',
                      style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '// PROGRESS_TRACK:',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                        Text(
                          '0${_currentIndex + 1} / ${_quizQuestions.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
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
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(color: AppColors.acidGreen),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Question Matrix Palette
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _quizQuestions.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 6),
                        itemBuilder: (context, idx) {
                          final isAnswered = _selectedAnswers.containsKey(idx);
                          final isCur = idx == _currentIndex;

                          Color bgColor;
                          Color textColor;
                          if (isCur) {
                            bgColor = AppColors.acidGreen;
                            textColor = AppColors.pitchBlack;
                          } else if (isAnswered) {
                            bgColor = isDark ? const Color(0xFF1E2E1E) : const Color(0xFFDCFCE7);
                            textColor = isDark ? AppColors.acidGreen : const Color(0xFF166534);
                          } else {
                            bgColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
                            textColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
                          }

                          return GestureDetector(
                            onTap: () => setState(() => _currentIndex = idx),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: bgColor,
                                border: Border.all(
                                  color: isCur ? (isDark ? Colors.white : AppColors.pitchBlack) : (isDark ? const Color(0xFF444444) : const Color(0xFFBBBBBB)),
                                  width: isCur ? 2.0 : 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${idx + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'monospace',
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Question Card Console
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
