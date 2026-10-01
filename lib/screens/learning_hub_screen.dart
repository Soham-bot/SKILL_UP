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
    if (mounted) _loadCourse();
  }

  void _loadCourse() {
    final c = widget.courseService.getCourseById(widget.courseId);
    if (c != null) setState(() => _course = c);
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

    final currentModule = _course.modules.firstWhere(
      (m) => !m.isCompleted,
      orElse: () => _course.modules.last,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('// ${_course.title.toUpperCase()} // HUB'),
        actions: [
          if (_course.status == CourseStatus.completed && _course.bestResult != null)
            IconButton(
              tooltip: 'VIEW_CREDENTIAL',
              icon: const Icon(Icons.workspace_premium_rounded, color: AppColors.acidGreen),
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
          child: allModulesDone
              ? FilledButton(
                  onPressed: _startAssessment,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.acidGreen,
                    foregroundColor: AppColors.pitchBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _course.status == CourseStatus.completed
                        ? '>>> RETAKE_FINAL_ASSESSMENT [10_MCQS] >>>'
                        : '>>> EXECUTE_FINAL_ASSESSMENT [10_MCQS] >>>',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                )
              : FilledButton(
                  onPressed: () => _openModule(currentModule),
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : AppColors.pitchBlack,
                    foregroundColor: isDark ? AppColors.pitchBlack : AppColors.acidGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('>>> RUN_NODE_0${currentModule.orderIndex} >>>'),
                ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Telemetry Panel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '// CURRICULUM_SYNC_STATUS:',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        color: allModulesDone ? AppColors.acidGreen : AppColors.neonYellow,
                        child: Text(
                          '$percent%_SYNCED',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: AppColors.pitchBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_course.completedModulesCount} OF ${_course.modules.length} MODULES SYNCHRONIZED',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Hard Brutalist Progress Bar
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF222222) : const Color(0xFFDDDDDD),
                      border: Border.all(
                        color: isDark ? Colors.white : AppColors.pitchBlack,
                        width: 1.5,
                      ),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _course.progress.clamp(0.0, 1.0),
                      child: Container(
                        color: allModulesDone ? AppColors.acidGreen : AppColors.neonYellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Completion Banner (If all 5 modules completed)
            if (allModulesDone) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.acidGreen,
                  border: Border.all(
                    color: isDark ? Colors.white : AppColors.pitchBlack,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.white : AppColors.pitchBlack,
                      offset: const Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: AppColors.pitchBlack,
                      child: const Icon(Icons.bolt_rounded, color: AppColors.acidGreen, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ALL 5 MODULES SYNCHRONIZED!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: AppColors.pitchBlack,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Protocol exam unlocked: 10 random MCQs will test all 5 nodes.',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                              color: AppColors.pitchBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 5 Modules List Header
            Text(
              '// EXECUTION_ROADMAP [05_UNITS]:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                letterSpacing: 1.0,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 10),

            ..._course.modules.map((module) {
              final isCur = !allModulesDone && module.id == currentModule.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
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
