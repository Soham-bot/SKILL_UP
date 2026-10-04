import 'package:flutter/material.dart';
import '../data/course_repository.dart';
import '../models/course.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';
import '../widgets/option_tile.dart';
import '../widgets/question_nav_strip.dart';
import '../widgets/responsive_container.dart';

class QuizScreen extends StatefulWidget {
  final String courseId;

  const QuizScreen({super.key, required this.courseId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final Course? _course;
  late final List<Question> _questions;
  int _currentIndex = 0;
  final Map<int, int> _answers = {}; // questionIndex -> chosenOptionIndex
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _course = CourseRepository.getById(widget.courseId);
    final course = _course;
    if (course != null) {
      _questions = QuizService.selectQuestionsForQuiz(course);
    } else {
      _questions = const [];
    }
  }

  Future<bool> _confirmLeave() async {
    final theme = Theme.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave assessment?'),
        content: const Text(
          'Your active answers will be lost if you leave now. Are you sure you want to exit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Stay'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _onOptionSelected(int optionIndex) {
    setState(() {
      _answers[_currentIndex] = optionIndex;
    });
  }

  void _navigateToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      setState(() {
        _currentIndex = index;
        _showHint = false;
      });
    }
  }

  void _goToReview() {
    final course = _course;
    if (course == null) return;
    Navigator.of(context).pushNamed(
      '/review',
      arguments: {
        'course': course,
        'questions': _questions,
        'answers': _answers,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final course = _course;
    if (course == null || _questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Assessment Unavailable')),
        body: const Center(child: Text('Questions could not be loaded.')),
      );
    }

    final totalQuestions = _questions.length;
    final currentQuestion = _questions[_currentIndex];
    final selectedOption = _answers[_currentIndex];
    final isLastQuestion = _currentIndex == totalQuestions - 1;
    final progressFraction = (_currentIndex + 1) / totalQuestions;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await _confirmLeave();
        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(course.title),
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Leave Assessment',
            onPressed: () async {
              final shouldLeave = await _confirmLeave();
              if (shouldLeave && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: progressFraction,
              minHeight: 4,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: colorScheme.primary,
            ),
          ),
        ),
        body: Column(
          children: [
            // Question Number Strip
            Container(
              color: colorScheme.surfaceContainer.withOpacity(0.5),
              child: QuestionNavStrip(
                totalQuestions: totalQuestions,
                currentIndex: _currentIndex,
                answers: _answers,
                onSelectQuestion: _navigateToQuestion,
              ),
            ),

            // Question & Options Content
            Expanded(
              child: SingleChildScrollView(
                child: ResponsiveContainer(
                  maxWidth: 680,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Question Counter & Answered Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_currentIndex + 1} of $totalQuestions',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: selectedOption != null
                                  ? colorScheme.primaryContainer
                                  : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              selectedOption != null ? 'Answered ✓' : 'Unanswered',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: selectedOption != null
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Question Prompt Card
                      Card(
                        color: colorScheme.surfaceContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: colorScheme.outline, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            currentQuestion.prompt,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Optional Hint Button (rendered ONLY if hint != null per null-safety spec)
                      if (currentQuestion.hint != null) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: colorScheme.tertiary,
                            ),
                            icon: Icon(
                              _showHint
                                  ? Icons.lightbulb
                                  : Icons.lightbulb_outline,
                              size: 16,
                            ),
                            label: Text(_showHint ? 'Hide Hint' : 'View Hint'),
                            onPressed: () {
                              setState(() {
                                _showHint = !_showHint;
                              });
                            },
                          ),
                        ),
                        if (_showHint && currentQuestion.hint != null)
                          Container(
                            margin: const EdgeInsets.only(top: 6, bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colorScheme.tertiaryContainer.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: colorScheme.tertiary.withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: colorScheme.tertiary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    currentQuestion.hint ?? '',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 6),
                      ],

                      // 4 Option Tiles
                      ...List.generate(currentQuestion.options.length, (optIdx) {
                        return OptionTile(
                          index: optIdx,
                          text: currentQuestion.options[optIdx],
                          isSelected: selectedOption == optIdx,
                          onTap: () => _onOptionSelected(optIdx),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                border: Border(
                  top: BorderSide(color: colorScheme.outline, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentIndex > 0)
                          OutlinedButton(
                            onPressed: () => _navigateToQuestion(_currentIndex - 1),
                            child: const Text('Previous'),
                          )
                        else
                          const SizedBox.shrink(),
                        if (!isLastQuestion)
                          FilledButton(
                            onPressed: () => _navigateToQuestion(_currentIndex + 1),
                            child: const Text('Next'),
                          )
                        else
                          FilledButton(
                            onPressed: _goToReview,
                            child: const Text('Review Answers'),
                          ),
                      ],
                    ),
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
