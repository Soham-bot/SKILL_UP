import 'package:flutter/material.dart';
import '../data/course_repository.dart';
import '../models/enums.dart';
import '../services/progress_scope.dart';
import '../widgets/responsive_container.dart';
import '../widgets/status_chip.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = ProgressScope.of(context);
    final course = CourseRepository.getById(courseId);

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Not Found')),
        body: const Center(child: Text('The requested course does not exist.')),
      );
    }

    final status = progress.getCourseStatus(course.id);
    final isEnrolled = progress.isEnrolled(course.id);
    final isCompleted = status == CourseStatus.completed;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(course.category),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: StatusChip(status: status)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ResponsiveContainer(
                maxWidth: 720,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title
                    Text(
                      course.title,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // SUMMARY ROW (Required by PS: title, duration, difficulty, question count)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outline, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem(
                            context,
                            Icons.tune_outlined,
                            'Difficulty',
                            course.difficulty.label,
                          ),
                          _buildDivider(context),
                          _buildSummaryItem(
                            context,
                            Icons.schedule_outlined,
                            'Duration',
                            '${course.duration.inMinutes} mins',
                          ),
                          _buildDivider(context),
                          _buildSummaryItem(
                            context,
                            Icons.quiz_outlined,
                            'Assessment',
                            '${course.quizQuestionCount} Questions',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // About this course
                    Text(
                      'About this course',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.85),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // What you'll learn
                    Text(
                      "What you'll learn",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...course.outcomes.map(
                      (outcome) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                outcome,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.85),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Course Content (5 lessons collapsed list)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Course content',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${course.lessons.length} lessons · ${course.duration.inMinutes} min total',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outline, width: 1),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: course.lessons.length,
                        separatorBuilder: (_, _) => Divider(
                          color: colorScheme.outline.withOpacity(0.5),
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final lesson = course.lessons[index];
                          final isLessonDone = progress.isLessonCompleted(course.id, lesson.id);

                          return ListTile(
                            leading: CircleAvatar(
                              radius: 14,
                              backgroundColor: isLessonDone
                                  ? colorScheme.primaryContainer
                                  : colorScheme.surfaceContainerHighest,
                              child: isLessonDone
                                  ? Icon(Icons.check, size: 14, color: colorScheme.primary)
                                  : Text(
                                      '${index + 1}',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                            ),
                            title: Text(
                              lesson.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            trailing: Text(
                              '${lesson.estimatedMinutes} min',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Final assessment info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.workspace_premium_outlined,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Final Assessment & Certification',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Complete all 5 lessons to unlock the 10-question evaluation. Pass mark is 60% with unlimited retakes. Earning a passing grade generates your official on-device verified certificate.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.8),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Sticky Bottom Bar
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
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            if (isCompleted) {
                              Navigator.of(context).pushNamed(
                                '/certificate',
                                arguments: course.id,
                              );
                            } else if (isEnrolled) {
                              Navigator.of(context).pushNamed(
                                '/learning-path',
                                arguments: course.id,
                              );
                            } else {
                              await progress.enroll(course.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("You're enrolled. Start your first lesson!"),
                                  ),
                                );
                                Navigator.of(context).pushNamed(
                                  '/learning-path',
                                  arguments: course.id,
                                );
                              }
                            }
                          },
                          child: Text(
                            isCompleted
                                ? 'View Certificate'
                                : (isEnrolled ? 'Continue Learning' : 'Enroll for Free'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 1,
      height: 32,
      color: colorScheme.outline.withOpacity(0.6),
    );
  }
}
