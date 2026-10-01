import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../utils/glitch_page_route.dart';
import '../widgets/wireframe_grid_background.dart';
import '../widgets/course_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/brutal_button.dart';
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
      GlitchPageRoute.push(
        context,
        CertificateScreen(
          courseService: courseService,
          quizResult: course.bestResult!,
        ),
      );
    } else if (course.status == CourseStatus.inProgress || course.status == CourseStatus.enrolled) {
      GlitchPageRoute.push(
        context,
        LearningHubScreen(
          courseService: courseService,
          courseId: course.id,
        ),
      );
    } else {
      GlitchPageRoute.push(
        context,
        CourseDetailScreen(
          courseService: courseService,
          course: course,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = courseService.profile;
    final learnerName = profile?.name ?? 'MAIN CHARACTER';
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
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  color: isDark ? AppColors.pitchBlack : AppColors.acidGreen,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('SKILLUP // 01_FEED'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'VIBE: FLASHBANG' : 'VIBE: VOID DARK',
            icon: Icon(isDark ? Icons.light_mode_sharp : Icons.dark_mode_sharp),
            onPressed: () => courseService.toggleTheme(),
          ),
        ],
      ),
      body: WireframeGridBackground(
        child: SafeArea(
          child: ListView(
            // Snap-Velocity Scrolling Momentum
            physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            children: [
              // Top Live Telemetry Ticker
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF141414) : const Color(0xFFE5E5DE),
                  border: Border.all(
                    color: isDark ? Colors.white : AppColors.pitchBlack,
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '>>> ZERO-PADDING BRUTALISM // FLUTTER',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '// NO CAP 🔥',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: AppColors.acidGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Operator Greeting & Asymmetric Z-Index Layering
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              color: isDark ? Colors.white : AppColors.pitchBlack,
                              child: Text(
                                '// MAIN CHARACTER',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  color: isDark ? AppColors.pitchBlack : AppColors.acidGreen,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '<VIBE: IMMACULATE>',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                color: AppColors.acidGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
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
                          'Pick a track. Grind 5 modules. Ace the 10-question final boss to flex your certificate. No cap.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            fontFamily: 'monospace',
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Asymmetric Rotated Sticker Overlay
                  Positioned(
                    top: -10,
                    right: 10,
                    child: Transform.rotate(
                      angle: -0.06,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.neonYellow,
                          border: Border.all(color: AppColors.pitchBlack, width: 2.0),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.pitchBlack,
                              offset: Offset(2, 2),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: const Text(
                          'RANK: GOAT IN TRAINING 🔥',
                          style: TextStyle(
                            fontSize: 9.5,
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

              const SizedBox(height: 16),

              // Telemetry Grid: Streak & Aura
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'DAILY STREAK',
                      value: '${profile?.streakDays ?? 1} DAYS',
                      icon: Icons.local_fire_department_sharp,
                      accentColor: const Color(0xFFFF5500),
                      subtitle: 'NEVER MISSED 🔥',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: 'AURA POINTS',
                      value: '${profile?.xp ?? 0}',
                      icon: Icons.bolt_sharp,
                      accentColor: AppColors.neonYellow,
                      subtitle: 'BANKED ON-DEVICE ✨',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Metric Tags
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.acidGreen,
                      border: Border.all(color: isDark ? Colors.white : AppColors.pitchBlack, width: 2),
                    ),
                    child: Text(
                      '[BIG W\'S: $completedCount CERTS]',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: AppColors.pitchBlack,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : AppColors.pitchBlack,
                      border: Border.all(color: isDark ? Colors.white : AppColors.pitchBlack, width: 2),
                    ),
                    child: Text(
                      '[GRINDING: ${inProgressCourses.length} TRACKS]',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: isDark ? AppColors.pitchBlack : Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFDDDDDD),
                      border: Border.all(color: isDark ? Colors.white : AppColors.pitchBlack, width: 1.5),
                    ),
                    child: const Text(
                      '<ZERO_L\'S // LOCKED_IN>',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // SECTION 1: CONTINUE LEARNING (Active Node)
              Text(
                '// WHAT YOU\'RE COOKING RN:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 6),

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
                        '<NOTHING COOKING RN 💀>',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pick a course below and start leveling up your skills on-device.',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      BrutalButton(
                        text: '>>> BROWSE ALL DROPS >>>',
                        onPressed: onNavigateToExplore,
                        backgroundColor: AppColors.acidGreen,
                        foregroundColor: AppColors.pitchBlack,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 22),

              // SECTION 2: EXPLORE COURSES (Grid)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '// CURRICULUM DROPS [04 TRACKS]:',
                    style: TextStyle(
                      fontSize: 11,
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
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: isDark ? AppColors.pitchBlack : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

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
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
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

              const SizedBox(height: 22),

              // SECTION 3: SYSTEM PROTOCOL UNLOCKS
              Text(
                '// BADGES & TROPHIES:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  _buildAchievementBadge(
                    context,
                    title: 'FIRST SYNC',
                    subtitle: 'ENROLLED 🔥',
                    isUnlocked: courseService.enrolledCourses.isNotEmpty,
                    angle: -0.04,
                  ),
                  const SizedBox(width: 8),
                  _buildAchievementBadge(
                    context,
                    title: '5 MODULES',
                    subtitle: 'TRACK BEATEN ✨',
                    isUnlocked: allCourses.any((c) => c.isFullyLearned),
                    angle: 0.05,
                  ),
                  const SizedBox(width: 8),
                  _buildAchievementBadge(
                    context,
                    title: 'CERTIFIED',
                    subtitle: 'HUGE W ≥60%',
                    isUnlocked: completedCount > 0,
                    angle: -0.03,
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
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
                  fontSize: 9.5,
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
