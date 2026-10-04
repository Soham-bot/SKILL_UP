import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/course_repository.dart';
import '../services/progress_scope.dart';
import '../widgets/responsive_container.dart';

class LessonScreen extends StatefulWidget {
  final String courseId;
  final int initialLessonIndex;

  const LessonScreen({
    super.key,
    required this.courseId,
    required this.initialLessonIndex,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late int _currentIndex;
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialLessonIndex;
    _scrollController.addListener(_updateScrollProgress);
  }

  void _updateScrollProgress() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    if (maxScroll <= 0) {
      setState(() => _scrollProgress = 1.0);
    } else {
      setState(() {
        _scrollProgress = (current / maxScroll).clamp(0.0, 1.0);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _changeLesson(int newIndex) {
    if (newIndex < 0) return;
    final course = CourseRepository.getById(widget.courseId);
    if (course == null || newIndex >= course.lessons.length) return;

    setState(() {
      _currentIndex = newIndex;
      _scrollProgress = 0.0;
    });
    _scrollController.jumpTo(0);
  }

  Future<void> _markAndContinue() async {
    final progress = ProgressScope.of(context);
    final course = CourseRepository.getById(widget.courseId);
    if (course == null) return;

    final currentLesson = course.lessons[_currentIndex];
    await progress.markLessonCompleted(course.id, currentLesson.id);

    if (!mounted) return;

    if (_currentIndex < course.lessons.length - 1) {
      _changeLesson(_currentIndex + 1);
    } else {
      // Reached end of lessons, navigate to Learning Path or assessment
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All lessons completed! Final Assessment is now unlocked.'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final course = CourseRepository.getById(widget.courseId);

    if (course == null || _currentIndex >= course.lessons.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson Not Found')),
        body: const Center(child: Text('Lesson could not be loaded.')),
      );
    }

    final lesson = course.lessons[_currentIndex];
    final isLastLesson = _currentIndex == course.lessons.length - 1;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(course.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _scrollProgress,
            minHeight: 4,
            backgroundColor: colorScheme.surfaceContainerHighest,
            color: colorScheme.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: ResponsiveContainer(
                maxWidth: 680, // Max 680 px wide for comfortable line length
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subhead: Lesson X of 5 · Y min read
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Lesson ${_currentIndex + 1} of ${course.lessons.length} · ${lesson.estimatedMinutes} min read',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Lesson Title
                    Text(
                      lesson.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Concept Explanation (3-5 short paragraphs)
                    ...lesson.conceptExplanation.split('\n\n').map(
                      (paragraph) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Text(
                          paragraph,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.9),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Key Points (3-5 bullets)
                    Text(
                      'Key Points',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outline, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: lesson.keyPoints.map(
                          (point) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6, right: 10),
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface.withOpacity(0.85),
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Code or Worked Example (monospace block, copyable)
                    if (lesson.codeExample != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Worked Example',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            icon: const Icon(Icons.copy_outlined, size: 14),
                            label: const Text('Copy code'),
                            onPressed: () {
                              final code = lesson.codeExample;
                              if (code != null) {
                                Clipboard.setData(ClipboardData(text: code));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Code copied to clipboard')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.outline, width: 1),
                        ),
                        child: SelectableText(
                          lesson.codeExample ?? '',
                          style: GoogleFonts.firaCode(
                            fontSize: 13,
                            height: 1.5,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Real-world Case Study Card
                    Card(
                      color: colorScheme.surfaceContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: colorScheme.outline, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'CASE STUDY',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    lesson.caseStudy.company,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildCaseSection(
                              context,
                              'Situation',
                              lesson.caseStudy.situation,
                            ),
                            _buildCaseSection(
                              context,
                              'Problem',
                              lesson.caseStudy.problem,
                            ),
                            _buildCaseSection(
                              context,
                              'Approach',
                              lesson.caseStudy.approach,
                            ),
                            _buildCaseSection(
                              context,
                              'Outcome',
                              lesson.caseStudy.outcome,
                            ),
                            _buildCaseSection(
                              context,
                              'Lesson Learned',
                              lesson.caseStudy.lessonLearned,
                              isHighlight: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Key Takeaways (2-3 lines)
                    Text(
                      'Key Takeaways',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorScheme.outline, width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: lesson.keyTakeaways.map(
                          (takeaway) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check, size: 16, color: colorScheme.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    takeaway,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface.withOpacity(0.85),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),

          // Footer with 'Mark as complete & continue' and 'Previous lesson'
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
                    children: [
                      if (_currentIndex > 0)
                        TextButton(
                          onPressed: () => _changeLesson(_currentIndex - 1),
                          child: const Text('Previous lesson'),
                        )
                      else
                        const SizedBox.shrink(),
                      const Spacer(),
                      FilledButton(
                        onPressed: _markAndContinue,
                        child: Text(
                          isLastLesson
                              ? 'Complete & Finish Lessons'
                              : 'Mark as Complete & Continue',
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

  Widget _buildCaseSection(
    BuildContext context,
    String label,
    String content, {
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: isHighlight
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.85),
              fontWeight: isHighlight ? FontWeight.w500 : FontWeight.w400,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
