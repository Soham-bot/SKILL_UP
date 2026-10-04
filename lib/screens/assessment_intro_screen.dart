import 'package:flutter/material.dart';
import '../data/course_repository.dart';
import '../services/progress_scope.dart';
import '../widgets/responsive_container.dart';

class AssessmentIntroScreen extends StatelessWidget {
  final String courseId;

  const AssessmentIntroScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = ProgressScope.of(context);
    final course = CourseRepository.getById(courseId);

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Not Found')),
        body: const Center(child: Text('Course not found.')),
      );
    }

    // Edge case check: If accessed before 5 lessons are completed, redirect back
    final isUnlocked = progress.isFinalAssessmentUnlocked(course.id);
    if (!isUnlocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please complete all 5 lessons before starting the assessment.'),
          ),
        );
        Navigator.of(context).pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final bestResult = progress.getBestResult(course.id);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Assessment Overview'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            maxWidth: 600,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Badge
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'CERTIFICATION EXAM',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  '${course.title} Final Assessment',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Evaluate your comprehension of the core architectural principles, applied case studies, and engineering concepts covered in this course.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Key Parameters Card (10 questions, 60% pass mark, no negative marking, no time limit)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outline, width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildRuleRow(
                        context,
                        Icons.format_list_numbered,
                        '10 Questions',
                        'Dynamically sampled from all 5 course lessons',
                      ),
                      const Divider(height: 24),
                      _buildRuleRow(
                        context,
                        Icons.percent,
                        '60% Passing Threshold',
                        'Score 6 of 10 or higher to earn your verified certificate',
                      ),
                      const Divider(height: 24),
                      _buildRuleRow(
                        context,
                        Icons.hourglass_empty,
                        'No Time Limit',
                        'Answer calmly without countdown pressure or rush',
                      ),
                      const Divider(height: 24),
                      _buildRuleRow(
                        context,
                        Icons.check_circle_outline,
                        'No Negative Marking',
                        'Attempt every question; unselected choices are marked wrong',
                      ),
                      const Divider(height: 24),
                      _buildRuleRow(
                        context,
                        Icons.rate_review_outlined,
                        'Review Before Submitting',
                        'Jump between questions and review answers before finalizing',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Best score notice if previously taken
                if (bestResult != null)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.history, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your best score: ${bestResult.score}/10 (${bestResult.percentage.toStringAsFixed(0)}%). Retaking will not erase a passed certificate.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),

                // Start Button
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      '/quiz',
                      arguments: course.id,
                    );
                  },
                  child: const Text('Start Assessment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRuleRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: colorScheme.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
