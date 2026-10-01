import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../utils/glitch_page_route.dart';
import '../widgets/wireframe_grid_background.dart';
import '../widgets/status_badge.dart';
import '../widgets/brutal_button.dart';
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
      GlitchPageRoute.pushReplacement(
        context,
        LearningHubScreen(
          courseService: widget.courseService,
          courseId: _course.id,
        ),
      );
    }
  }

  void _handleViewCertificate() {
    if (_course.bestResult != null) {
      GlitchPageRoute.push(
        context,
        CertificateScreen(
          courseService: widget.courseService,
          quizResult: _course.bestResult!,
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
      // Single-Thumb Velocity Reach Zone
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
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
                  child: BrutalButton(
                    text: '// REVIEW_NODE',
                    onPressed: () {
                      GlitchPageRoute.push(
                        context,
                        LearningHubScreen(
                          courseService: widget.courseService,
                          courseId: _course.id,
                        ),
                      );
                    },
                    backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE5E5DE),
                    foregroundColor: isDark ? Colors.white : AppColors.pitchBlack,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BrutalButton(
                    text: 'VIEW_CERTIFICATE',
                    onPressed: _handleViewCertificate,
                    backgroundColor: AppColors.acidGreen,
                    foregroundColor: AppColors.pitchBlack,
                  ),
                ),
              ] else if (_course.status == CourseStatus.inProgress ||
                  _course.status == CourseStatus.enrolled) ...[
                Expanded(
                  child: BrutalButton(
                    text: _course.progress > 0
                        ? '>>> RESUME_NODE ($percent%) >>>'
                        : '>>> ENTER_HUB >>>',
                    onPressed: _handleEnrollAndStart,
                    backgroundColor: AppColors.acidGreen,
                    foregroundColor: AppColors.pitchBlack,
                  ),
                ),
              ] else ...[
                Expanded(
                  child: BrutalButton(
                    text: '>>> INITIALIZE_FREE_ENROLLMENT >>>',
                    onPressed: _handleEnrollAndStart,
                    backgroundColor: AppColors.acidGreen,
                    foregroundColor: AppColors.pitchBlack,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      body: WireframeGridBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Badges
              Row(
                children: [
                  StatusBadge.category(_course.category),
                  const SizedBox(width: 8),
                  StatusBadge.difficulty(_course.difficulty),
                ],
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                _course.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: -0.5,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _course.fullDescription,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.45,
                  fontFamily: 'monospace',
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),

              const SizedBox(height: 16),

              // Telemetry Metric Box
              Container(
                padding: const EdgeInsets.all(12),
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

              const SizedBox(height: 22),

              // Acquired Capabilities
              Text(
                '// ACQUIRED_CAPABILITIES:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                ),
              ),
              const SizedBox(height: 8),

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

              const SizedBox(height: 22),

              // 5 Syllabus Nodes
              Text(
                '// SYLLABUS_NODES [05_UNITS]:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 8),

              ..._course.modules.map((module) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      border: Border.all(
                        color: isDark ? Colors.white : AppColors.pitchBlack,
                        width: 1.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: module.isCompleted
                                ? AppColors.acidGreen
                                : (isDark ? const Color(0xFF222222) : const Color(0xFFE5E5DE)),
                            border: Border.all(
                              color: isDark ? Colors.white : AppColors.pitchBlack,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '0${module.orderIndex}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                color: isDark && !module.isCompleted
                                    ? Colors.white
                                    : AppColors.pitchBlack,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                module.title.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                '// READ_TIME: ${module.estimatedMinutes.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 9.5,
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

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 2,
      height: 24,
      color: isDark ? const Color(0xFF333333) : const Color(0xFFCCCCCC),
    );
  }
}
