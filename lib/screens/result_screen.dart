import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import '../services/progress_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_container.dart';

class ResultScreen extends StatelessWidget {
  final QuizResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColors = theme.extension<AppStatusColors>() ?? AppStatusColors.light;
    final progress = ProgressScope.of(context);
    final bestResult = progress.getBestResult(result.courseId);

    final isPassed = result.passed;
    final badgeBg = isPassed ? statusColors.successContainer : statusColors.warningContainer;
    final badgeFg = isPassed ? statusColors.onSuccessContainer : statusColors.onWarningContainer;
    final badgeBorder = isPassed ? statusColors.success : statusColors.warning;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Assessment Result'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Return to Catalog',
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ResponsiveContainer(
            maxWidth: 680,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Result Summary Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outline, width: 1),
                  ),
                  child: Column(
                    children: [
                      // Status Badge (Check / Info, never harsh red)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: badgeBorder.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPassed ? Icons.check_circle : Icons.info_outline,
                              size: 16,
                              color: badgeFg,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isPassed ? 'PASSED' : 'NOT PASSED',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: badgeFg,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Large Score Display
                      Text(
                        '${result.score} / ${result.totalQuestions}',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Percentage
                      Text(
                        '${result.percentage.toStringAsFixed(0)}% Score',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Professional Tone Message
                      Text(
                        isPassed
                            ? 'You passed. Well done! Your mastery of the material has been verified on-device.'
                            : 'Not passed this time — you scored ${result.score} of ${result.totalQuestions}. Pass mark is 60%. Review the lessons or try again whenever you\'re ready.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.8),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // Best score indicator if retaken
                      if (bestResult != null && bestResult.score != result.score) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Best score recorded: ${bestResult.score}/10 (${bestResult.percentage.toStringAsFixed(0)}%)',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Primary & Secondary Actions
                if (isPassed) ...[
                  FilledButton.icon(
                    icon: const Icon(Icons.workspace_premium_outlined),
                    label: const Text('View Certificate'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/certificate',
                        arguments: result.courseId,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
                    },
                    child: const Text('Back to Home'),
                  ),
                ] else ...[
                  FilledButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake Assessment'),
                    onPressed: () {
                      // Fresh state, new randomized 10 questions without app restart
                      Navigator.of(context).pushReplacementNamed(
                        '/quiz',
                        arguments: result.courseId,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/learning-path',
                        arguments: result.courseId,
                      );
                    },
                    child: const Text('Review Lessons'),
                  ),
                ],
                const SizedBox(height: 28),

                // Answer Review Section (Expandable List)
                Text(
                  'Detailed Answer Review',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: result.questions.length,
                  itemBuilder: (context, index) {
                    final q = result.questions[index];
                    final chosenIdx = result.selectedAnswers[index];
                    final isCorrect = chosenIdx != null && chosenIdx == q.correctIndex;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        color: colorScheme.surfaceContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isCorrect
                                ? statusColors.success.withOpacity(0.5)
                                : statusColors.warning.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: ExpansionTile(
                          shape: const Border(),
                          collapsedShape: const Border(),
                          leading: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? statusColors.successContainer
                                    : statusColors.warningContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCorrect ? Icons.check : Icons.close,
                                size: 16,
                                color: isCorrect
                                    ? statusColors.onSuccessContainer
                                    : statusColors.onWarningContainer,
                              ),
                            ),
                            title: Text(
                              'Q${index + 1}: ${q.prompt}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              isCorrect ? 'Correct ✓' : 'Incorrect',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isCorrect ? statusColors.success : statusColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    const SizedBox(height: 6),
                                    _buildReviewLine(
                                      context,
                                      'Your Answer',
                                      chosenIdx != null
                                          ? q.options[chosenIdx]
                                          : 'Unanswered',
                                      isGood: isCorrect,
                                    ),
                                    const SizedBox(height: 6),
                                    _buildReviewLine(
                                      context,
                                      'Correct Answer',
                                      q.options[q.correctIndex],
                                      isGood: true,
                                    ),
                                    // Explanation ONLY rendered if explanation != null per null-safety spec
                                    if (q.explanation != null) ...[
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Explanation: ${q.explanation!}',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurface.withOpacity(0.85),
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewLine(
    BuildContext context,
    String label,
    String value, {
    required bool isGood,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColors = theme.extension<AppStatusColors>() ?? AppStatusColors.light;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isGood ? statusColors.success : statusColors.warning,
            ),
          ),
        ),
      ],
    );
  }
}
