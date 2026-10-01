import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../widgets/course_card.dart';
import '../widgets/stat_card.dart';
import 'course_detail_screen.dart';
import 'learning_hub_screen.dart';
import 'certificate_screen.dart';

class HomeScreen extends StatelessWidget {
  final CourseService courseService;
  final VoidCallback onNavigateToExplore;

  const HomeScreen({
    super.key,
    required this.courseService,
    required this.onNavigateToExplore,
  });

  void _onCourseTap(BuildContext context, Course course) {
    if (course.status == CourseStatus.completed && course.bestResult != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CertificateScreen(
            courseService: courseService,
            quizResult: course.bestResult!,
          ),
        ),
      );
    } else if (course.status == CourseStatus.inProgress || course.status == CourseStatus.enrolled) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LearningHubScreen(
            courseService: courseService,
            courseId: course.id,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CourseDetailScreen(
            courseService: courseService,
            course: course,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = courseService.profile;
    final learnerName = profile?.name ?? 'OPERATOR';
    final completedCount = courseService.completedCourses.length;
    final inProgressCourses = courseService.inProgressCourses;
    final allCourses = courseService.courses;

    final activeCourse = inProgressCourses.isNotEmpty
        ? inProgressCourses.first
        : (courseService.enrolledCourses.isNotEmpty ? courseService.enrolledCourses.first : null);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
              child: Text(
                'SKL',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  color: isDark ? AppColors.pitchBlack : AppColors.acidGreen,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('SKILLUP // CORE'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'INVERT_THEME: LIGHT' : 'INVERT_THEME: DARK',
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: () => courseService.toggleTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Top Live Telemetry Ticker
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: isDark ? const Color(0xFF161616) : const Color(0xFFE5E5DE),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '>>> RUNTIME: ON_DEVICE_DART',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                  ),
                  Text(
                    '// API: NULL // ZERO_LATENCY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      color: AppColors.acidGreen,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Operator Greeting & Asymmetric Sticker
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
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
                      Text(
                        '// LOGGED_OPERATOR:',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${learnerName.toUpperCase()} ⚡',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          letterSpacing: -0.5,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Select a skill node. Execute 5 modules. Verify competence via 10-MCQ protocol.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Asymmetric Rotated Sticker Overlay
                Positioned(
                  top: -8,
                  right: 12,
                  child: Transform.rotate(
                    angle: 0.05,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.neonYellow,
                        border: Border.all(color: AppColors.pitchBlack, width: 1.5),
                      ),
                      child: const Text(
                        'RANK: APPRENTICE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: AppColors.pitchBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Telemetry Grid: Streak & XP (Hard brutalist cards)
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'STREAK_CYCLE',
                    value: '${profile?.streakDays ?? 1} DAYS',
                    icon: Icons.local_fire_department_rounded,
                    accentColor: const Color(0xFFFF5500),
                    subtitle: 'CYCLE_ACTIVE',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'ACCUM_XP',
                    value: '${profile?.xp ?? 0}',
                    icon: Icons.bolt_rounded,
                    accentColor: AppColors.neonYellow,
                    subtitle: 'LOCAL_BUFFER',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Hard Brutalist Metric Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.acidGreen,
                    border: Border.all(color: isDark ? Colors.white : AppColors.pitchBlack, width: 2),
                  ),
                  child: Text(
                    '[CERTIFIED: $completedCount NODES]',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      color: AppColors.pitchBlack,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : AppColors.pitchBlack,
                    border: Border.all(color: isDark ? Colors.white : AppColors.pitchBlack, width: 2),
                  ),
                  child: Text(
                    '[IN_FLIGHT: ${inProgressCourses.length}]',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      color: isDark ? AppColors.pitchBlack : Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // SECTION 1: CONTINUE LEARNING (Active Node)
            Text(
              '// ACTIVE_EXECUTION_NODE:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                letterSpacing: 1.0,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 8),

            if (activeCourse != null)
              CourseCard(
                course: activeCourse,
                isFeatured: true,
                onTap: () => _onCourseTap(context, activeCourse),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.pitchBlack,
                      offset: const Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '// STANDBY: NO ACTIVE NODE',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Select a course below to initialize module execution.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: onNavigateToExplore,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        color: AppColors.acidGreen,
                        child: const Text(
                          '>>> BROWSE_ALL_NODES >>>',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: AppColors.pitchBlack,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // SECTION 2: EXPLORE COURSES (Grid)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '// CURRICULUM_MATRIX:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    letterSpacing: 1.0,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                GestureDetector(
                  onTap: onNavigateToExplore,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: isDark ? Colors.white : AppColors.pitchBlack,
                    child: Text(
                      'EXPAND_ALL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: isDark ? AppColors.pitchBlack : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // GridView of Course Nodes
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 2 : 1,
                    childAspectRatio: isWide ? 1.25 : 1.28,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: allCourses.length,
                  itemBuilder: (context, index) {
                    final course = allCourses[index];
                    return CourseCard(
                      course: course,
                      onTap: () => _onCourseTap(context, course),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // SECTION 3: SYSTEM BADGE STAMPS
            Text(
              '// PROTOCOL_UNLOCKS:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                letterSpacing: 1.0,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                _buildAchievementBadge(
                  context,
                  title: 'INITIAL_SYNC',
                  subtitle: 'ENROLLED',
                  isUnlocked: courseService.enrolledCourses.isNotEmpty,
                  angle: -0.03,
                ),
                const SizedBox(width: 8),
                _buildAchievementBadge(
                  context,
                  title: '5_MODULES',
                  subtitle: 'SYLLABUS_DONE',
                  isUnlocked: allCourses.any((c) => c.isFullyLearned),
                  angle: 0.02,
                ),
                const SizedBox(width: 8),
                _buildAchievementBadge(
                  context,
                  title: 'CERTIFIED',
                  subtitle: 'ASSESS_PASS',
                  isUnlocked: completedCount > 0,
                  angle: -0.02,
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isUnlocked,
    double angle = 0.0,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: isUnlocked
                ? AppColors.neonYellow
                : (isDark ? const Color(0xFF141414) : const Color(0xFFEBEBE5)),
            border: Border.all(
              color: isDark ? Colors.white : AppColors.pitchBlack,
              width: 2.0,
            ),
            boxShadow: isUnlocked
                ? [
                    BoxShadow(
                      color: isDark ? Colors.white.withValues(alpha: 0.3) : AppColors.pitchBlack,
                      offset: const Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  color: isUnlocked
                      ? AppColors.pitchBlack
                      : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                  color: isUnlocked
                      ? AppColors.pitchBlack
                      : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
