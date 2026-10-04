import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/question.dart';
import '../services/progress_scope.dart';
import '../services/quiz_service.dart';
import '../widgets/responsive_container.dart';

class ReviewScreen extends StatefulWidget {
  final Course course;
  final List<Question> questions;
  final Map<int, int> answers;

  const ReviewScreen({
    super.key,
    required this.course,
    required this.questions,
    required this.answers,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _isSubmitting = false;

  int get _answeredCount => widget.answers.length;
  int get _unansweredCount => widget.questions.length - _answeredCount;

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return; // Prevent double-tap idempotency

    if (_unansweredCount > 0) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Submit with unanswered questions?'),
          content: Text(
            '$_unansweredCount question${_unansweredCount == 1 ? '' : 's'} are unanswered and will be marked incorrect. Would you like to submit anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Review Again'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Submit Anyway'),
            ),
          ],
        ),
      );

      if (confirm != true) return;
      if (!mounted) return;
    }

    final progress = ProgressScope.of(context);
    setState(() {
      _isSubmitting = true;
    });
    final result = QuizService.evaluate(
      course: widget.course,
      questions: widget.questions,
      answers: widget.answers,
      learnerName: progress.learnerName,
    );

    // Persist result and best score
    await progress.recordResult(result);

    if (!mounted) return;

    // Replace all routes back to main and push Result screen so Back does not re-enter finished quiz
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/result',
      (route) => route.isFirst,
      arguments: result,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalQuestions = widget.questions.length;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Review & Submit'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ResponsiveContainer(
                maxWidth: 680,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Overview Summary Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outline, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Answered $_answeredCount of $totalQuestions',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _unansweredCount == 0
                                      ? colorScheme.primaryContainer
                                      : colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _unansweredCount == 0
                                      ? 'All Answered ✓'
                                      : '$_unansweredCount Remaining',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: _unansweredCount == 0
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: totalQuestions > 0
                                  ? _answeredCount / totalQuestions
                                  : 0,
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Questions Summary',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Questions List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: totalQuestions,
                      itemBuilder: (context, index) {
                        final question = widget.questions[index];
                        final isAnswered = widget.answers.containsKey(index);
                        final selectedOption = widget.answers[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            color: colorScheme.surfaceContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: colorScheme.outline, width: 0.8),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 14,
                                backgroundColor: isAnswered
                                    ? colorScheme.primaryContainer
                                    : colorScheme.surfaceContainerHighest,
                                child: Text(
                                  '${index + 1}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isAnswered
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              title: Text(
                                question.prompt,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                isAnswered
                                    ? 'Selected: ${question.options[selectedOption!]}'
                                    : 'Not answered',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isAnswered
                                      ? colorScheme.primary
                                      : colorScheme.onSurface.withOpacity(0.55),
                                  fontWeight: isAnswered ? FontWeight.w500 : FontWeight.w400,
                                ),
                              ),
                              trailing: TextButton(
                                style: TextButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Back to quiz
                                },
                                child: const Text('Change'),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Bar: Submit Action
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
                  child: FilledButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Submit Final Assessment'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
