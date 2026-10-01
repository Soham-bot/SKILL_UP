import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../widgets/status_badge.dart';
import 'learning_hub_screen.dart';
import 'certificate_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseService courseService;
  final Course course;

  const CourseDetailScreen({
    super.key,
    required this.courseService,
    required this.course,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Course _course;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
  }

  void _handleEnrollAndStart() async {
    if (_course.status == CourseStatus.available) {
      await widget.courseService.enroll(_course.id);
      final updated = widget.courseService.getCourseById(_course.id);
      if (updated != null) {
        setState(() => _course = updated);
      }
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LearningHubScreen(
            courseService: widget.courseService,
            courseId: _course.id,
          ),
        ),
      );
    }
  }

  void _handleViewCertificate() {
    if (_course.bestResult != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CertificateScreen(
            courseService: widget.courseService,
            quizResult: _course.bestResult!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percent = (_course.progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text('// ${_course.title.toUpperCase()}'),
        actions: [
          if (_course.status == CourseStatus.completed)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: StatusBadge.completed(),
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
          child: Row(
            children: [
              if (_course.status == CourseStatus.completed) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LearningHubScreen(
                            courseService: widget.courseService,
                            courseId: _course.id,
                          ),
                        ),
                      );
                    },
                    child: const Text('// REVIEW_NODE'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _handleViewCertificate,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.acidGreen,
                      foregroundColor: AppColors.pitchBlack,
                    ),
                    child: const Text('VIEW_CERTIFICATE'),
                  ),
                ),
              ] else if (_course.status == CourseStatus.inProgress ||
                  _course.status == CourseStatus.enrolled) ...[
                Expanded(
                  child: FilledButton(
                    onPressed: _handleEnrollAndStart,
                    child: Text(
                      _course.progress > 0
                          ? '>>> RESUME_NODE ($percent%) >>>'
                          : '>>> ENTER_HUB >>>',
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: FilledButton(
                    onPressed: _handleEnrollAndStart,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.acidGreen,
                      foregroundColor: AppColors.pitchBlack,
                    ),
                    child: const Text('>>> INITIALIZE_FREE_ENROLLMENT >>>'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Badges
            Row(
              children: [
                StatusBadge.category(_course.category),
                const SizedBox(width: 8),
                StatusBadge.difficulty(_course.difficulty),
              ],
            ),

            const SizedBox(height: 14),

            // Course Title
            Text(
              _course.title.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              _course.fullDescription,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),

            const SizedBox(height: 18),

            // Telemetry Metric Row (Hard brutalist box)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141414) : const Color(0xFFEBEBE5),
                border: Border.all(
                  color: isDark ? Colors.white : AppColors.pitchBlack,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                    offset: const Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric('DURATION', _course.duration.toUpperCase()),
                  _buildDivider(isDark),
                  _buildMetric('MODULES', '${_course.modules.length}_UNITS'),
                  _buildDivider(isDark),
                  _buildMetric('ASSESSMENT', '10_MCQS'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Competencies Checklist
            Text(
              '// ACQUIRED_CAPABILITIES:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
              ),
            ),
            const SizedBox(height: 10),

            ..._course.skillsLearned.map((skill) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    border: Border.all(
                      color: isDark ? const Color(0xFF333333) : const Color(0xFFCCCCCC),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        '► ',
                        style: TextStyle(
                          color: AppColors.acidGreen,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          skill.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 24),

            // 5 Learning Modules Overview
            Text(
              '// SYLLABUS_NODES [05_UNITS]:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 10),

            ..._course.modules.map((module) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    border: Border.all(
                      color: isDark ? Colors.white : AppColors.pitchBlack,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: module.isCompleted ? AppColors.acidGreen : (isDark ? const Color(0xFF222222) : const Color(0xFFE5E5DE)),
                          border: Border.all(
                            color: isDark ? Colors.white : AppColors.pitchBlack,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '0${module.orderIndex}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: isDark && !module.isCompleted ? Colors.white : AppColors.pitchBlack,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              module.title.toUpperCase(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              '// READ_TIME: ${module.estimatedMinutes.toUpperCase()}',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'monospace',
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 2,
      height: 28,
      color: isDark ? const Color(0xFF333333) : const Color(0xFFCCCCCC),
    );
  }
}
