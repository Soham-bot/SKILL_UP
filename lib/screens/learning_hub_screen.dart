import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/learning_module.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../widgets/module_tile.dart';
import 'learning_module_screen.dart';
import 'quiz_screen.dart';
import 'certificate_screen.dart';

class LearningHubScreen extends StatefulWidget {
  final CourseService courseService;
  final String courseId;

  const LearningHubScreen({
    super.key,
    required this.courseService,
    required this.courseId,
  });

  @override
  State<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends State<LearningHubScreen> {
  late Course _course;

  @override
  void initState() {
    super.initState();
    _loadCourse();
    widget.courseService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    widget.courseService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) {
      _loadCourse();
    }
  }

  void _loadCourse() {
    final c = widget.courseService.getCourseById(widget.courseId);
    if (c != null) {
      setState(() => _course = c);
    }
  }

  void _openModule(LearningModule module) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningModuleScreen(
          courseService: widget.courseService,
          course: _course,
          module: module,
        ),
      ),
    );
  }

  void _startAssessment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          courseService: widget.courseService,
          course: _course,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percent = (_course.progress * 100).toInt();
    final allModulesDone = _course.isFullyLearned;

    // Find current active module (first incomplete module)
    final currentModule = _course.modules.firstWhere(
      (m) => !m.isCompleted,
      orElse: () => _course.modules.last,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_course.title),
        actions: [
          if (_course.status == CourseStatus.completed && _course.bestResult != null)
            IconButton(
              tooltip: 'View Certificate',
              icon: const Icon(Icons.workspace_premium_rounded, color: AppColors.accent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CertificateScreen(
                      courseService: widget.courseService,
                      quizResult: _course.bestResult!,
                    ),
                  ),
                );
              },
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
          child: allModulesDone
              ? FilledButton.icon(
                  onPressed: _startAssessment,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.quiz_rounded, size: 20),
                  label: Text(
                    _course.status == CourseStatus.completed
                        ? 'RETAKE FINAL ASSESSMENT'
                        : 'TAKE FINAL ASSESSMENT (10 MCQs)',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                )
              : FilledButton.icon(
                  onPressed: () => _openModule(currentModule),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.play_circle_fill_rounded, size: 20),
                  label: Text('Continue Module ${currentModule.orderIndex}'),
                ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COURSE PROGRESS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_course.completedModulesCount} of ${_course.modules.length} Modules Complete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: allModulesDone
                              ? AppColors.success.withOpacity(0.12)
                              : AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$percent%',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: allModulesDone ? AppColors.success : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _course.progress,
                      minHeight: 8,
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        allModulesDone ? AppColors.success : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Completion Banner (If all 5 modules done)
            if (allModulesDone) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.celebration_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🎉 COURSE CONTENT COMPLETE',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: isDark ? Colors.white : const Color(0xFF065F46),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'You’ve completed all five learning modules! Final assessment of 10 random MCQs is now unlocked.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF047857),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Section Header: 5 Modules Roadmap
            Text(
              '5 LEARNING MODULES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 12),

            // Modules List
            ..._course.modules.map((module) {
              final isCur = !allModulesDone && module.id == currentModule.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ModuleTile(
                  module: module,
                  isCurrent: isCur,
                  onTap: () => _openModule(module),
                ),
              );
            }),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
