import 'package:flutter/material.dart';
import '../data/course_repository.dart';
import '../models/enums.dart';
import '../services/certificate_pdf_service.dart';
import '../services/progress_scope.dart';
import '../widgets/empty_state.dart';
import '../widgets/responsive_container.dart';
import '../widgets/status_chip.dart';

class MyLearningScreen extends StatelessWidget {
  const MyLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = ProgressScope.of(context);

    final inProgressCourses = CourseRepository.allCourses.where((c) {
      final status = progress.getCourseStatus(c.id);
      return status == CourseStatus.inProgress || status == CourseStatus.attempted;
    }).toList();

    final completedCourses = CourseRepository.allCourses.where((c) {
      final status = progress.getCourseStatus(c.id);
      return status == CourseStatus.completed;
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('My Learning'),
          bottom: TabBar(
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
            tabs: [
              Tab(
                text: 'In Progress (${inProgressCourses.length})',
              ),
              Tab(
                text: 'Completed (${completedCourses.length})',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: In Progress
            inProgressCourses.isEmpty
                ? EmptyState(
                    icon: Icons.book_outlined,
                    title: 'No courses in progress',
                    message:
                        'Explore our catalog on the Home tab to discover skills and begin learning.',
                    actionLabel: 'Browse Courses',
                    onAction: () {
                      Navigator.of(context).pushReplacementNamed('/main');
                    },
                  )
                : ResponsiveContainer(
                    maxWidth: 720,
                    child: ListView.builder(
                      itemCount: inProgressCourses.length,
                      itemBuilder: (context, index) {
                        final course = inProgressCourses[index];
                        final done = progress.completedLessonsCount(course.id);
                        final total = course.lessons.length;
                        final fraction = total > 0 ? done / total : 0.0;
                        final status = progress.getCourseStatus(course.id);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Card(
                            color: colorScheme.surfaceContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          course.title,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      StatusChip(status: status),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: fraction,
                                      minHeight: 6,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$done of $total lessons done',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.65),
                                        ),
                                      ),
                                      FilledButton.tonal(
                                        style: FilledButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            '/learning-path',
                                            arguments: course.id,
                                          );
                                        },
                                        child: Text(
                                          done >= total
                                              ? 'Take Assessment'
                                              : 'Continue',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            // Tab 2: Completed (Certificates)
            completedCourses.isEmpty
                ? EmptyState(
                    icon: Icons.workspace_premium_outlined,
                    title: 'No certificates earned yet',
                    message:
                        'Pass a final assessment with a score of 60% or higher to earn and download your certificate.',
                  )
                : ResponsiveContainer(
                    maxWidth: 720,
                    child: ListView.builder(
                      itemCount: completedCourses.length,
                      itemBuilder: (context, index) {
                        final course = completedCourses[index];
                        final bestResult = progress.getBestResult(course.id);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Card(
                            color: colorScheme.surfaceContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: colorScheme.tertiaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.workspace_premium,
                                          color:
                                              colorScheme.onTertiaryContainer,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              course.title,
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              bestResult != null
                                                  ? 'Score: ${bestResult.score}/10 (${bestResult.percentage.toStringAsFixed(0)}%) · ID: ${bestResult.id}'
                                                  : 'Certificate of Completion',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        icon: const Icon(Icons.download, size: 16),
                                        label: const Text('Download'),
                                        onPressed: bestResult != null
                                            ? () => CertificatePdfService.shareOrSave(
                                                  bestResult,
                                                )
                                            : null,
                                      ),
                                      const SizedBox(width: 10),
                                      FilledButton.icon(
                                        style: FilledButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        icon: const Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 16),
                                        label: const Text('View'),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            '/certificate',
                                            arguments: course.id,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
