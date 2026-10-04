import 'package:flutter/material.dart';
import '../data/course_repository.dart';
import '../services/progress_scope.dart';
import '../widgets/responsive_container.dart';

class LearningPathScreen extends StatelessWidget {
  final String courseId;

  const LearningPathScreen({super.key, required this.courseId});

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

    final completedCount = progress.completedLessonsCount(course.id);
    final totalLessons = course.lessons.length;
    final isAssessmentUnlocked = progress.isFinalAssessmentUnlocked(course.id);
    final progressFraction = totalLessons > 0 ? completedCount / totalLessons : 0.0;

    // Identify the "current / next recommended" lesson index
    int recommendedIndex = 0;
    for (int i = 0; i < course.lessons.length; i++) {
      if (!progress.isLessonCompleted(course.id, course.lessons[i].id)) {
        recommendedIndex = i;
        break;
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Learning Path'),
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          maxWidth: 720,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Title & Progress Header
              Text(
                course.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              // Progress Bar & Counter
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outline, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedCount of $totalLessons lessons completed',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${(progressFraction * 100).toInt()}%',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progressFraction,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Lessons Checklist',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Lessons may be opened in any order. Finish all 5 to unlock the final certification exam.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),

              // 5 Lessons Checklist
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: course.lessons.length,
                itemBuilder: (context, index) {
                  final lesson = course.lessons[index];
                  final isDone = progress.isLessonCompleted(course.id, lesson.id);
                  final isCurrent = !isDone && index == recommendedIndex;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      color: isCurrent
                          ? colorScheme.primaryContainer.withOpacity(0.4)
                          : colorScheme.surfaceContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isCurrent
                              ? colorScheme.primary
                              : colorScheme.outline,
                          width: isCurrent ? 1.5 : 1.0,
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/lesson',
                            arguments: {
                              'courseId': course.id,
                              'lessonIndex': index,
                            },
                          );
                        },
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isDone
                                ? colorScheme.primary
                                : (isCurrent
                                    ? colorScheme.primaryContainer
                                    : colorScheme.surfaceContainerHighest),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: isDone
                                ? Icon(Icons.check, size: 20, color: colorScheme.onPrimary)
                                : Text(
                                    '${index + 1}',
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isCurrent
                                          ? colorScheme.onPrimaryContainer
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                          ),
                        ),
                        title: Text(
                          lesson.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          isDone
                              ? 'Completed ✓'
                              : (isCurrent ? 'Recommended next' : 'Up next'),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isDone
                                ? colorScheme.primary
                                : (isCurrent
                                    ? colorScheme.primary
                                    : colorScheme.onSurface.withOpacity(0.55)),
                            fontWeight: isDone || isCurrent
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${lesson.estimatedMinutes} min',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // FINAL ASSESSMENT CARD (Locked until all 5 done)
              Card(
                color: isAssessmentUnlocked
                    ? colorScheme.surfaceContainer
                    : colorScheme.surfaceContainerHigh.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: isAssessmentUnlocked
                        ? colorScheme.tertiary
                        : colorScheme.outline.withOpacity(0.6),
                    width: isAssessmentUnlocked ? 1.5 : 1.0,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () {
                    if (isAssessmentUnlocked) {
                      Navigator.of(context).pushNamed(
                        '/assessment-intro',
                        arguments: course.id,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Complete all $totalLessons lessons to unlock the Final Assessment ($completedCount/$totalLessons completed).',
                          ),
                        ),
                      );
                    }
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isAssessmentUnlocked
                          ? colorScheme.tertiaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isAssessmentUnlocked
                          ? Icons.lock_open_outlined
                          : Icons.lock_outline,
                      color: isAssessmentUnlocked
                          ? colorScheme.onTertiaryContainer
                          : colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  title: Text(
                    'Final Assessment & Certification',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isAssessmentUnlocked
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withOpacity(0.55),
                    ),
                  ),
                  subtitle: Text(
                    isAssessmentUnlocked
                        ? '10 Questions · Pass mark 60% · Unlocked'
                        : 'Complete all 5 lessons to unlock',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isAssessmentUnlocked
                          ? colorScheme.tertiary
                          : colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: isAssessmentUnlocked
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: isAssessmentUnlocked
                        ? colorScheme.tertiary
                        : colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
