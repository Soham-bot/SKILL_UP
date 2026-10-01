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

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

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
    final learnerName = profile?.name ?? 'Learner';
    final completedCount = courseService.completedCourses.length;
    final inProgressCourses = courseService.inProgressCourses;
    final allCourses = courseService.courses;

    // Determine currently active course for "Continue Learning"
    final activeCourse = inProgressCourses.isNotEmpty
        ? inProgressCourses.first
        : (courseService.enrolledCourses.isNotEmpty ? courseService.enrolledCourses.first : null);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.school_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SKILLUP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  'LEVEL UP YOUR SKILLS',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => courseService.toggleTheme(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Greeting & Motivation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getTimeGreeting()}, $learnerName 👋',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ready to level up your engineering skills?',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Gamified Metric Cards (Streak & XP)
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Learning Streak',
                    value: '${profile?.streakDays ?? 1} DAYS',
                    icon: Icons.local_fire_department_rounded,
                    accentColor: const Color(0xFFF97316),
                    subtitle: 'Keep it going!',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Total XP',
                    value: '${profile?.xp ?? 0}',
                    icon: Icons.bolt_rounded,
                    accentColor: AppColors.accent,
                    subtitle: 'Rank: Apprentice',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Quick Status Pills
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.success.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '$completedCount Courses Completed',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '${inProgressCourses.length} In Progress',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // SECTION 1: CONTINUE LEARNING
            Text(
              'CONTINUE LEARNING',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 10),

            if (activeCourse != null)
              CourseCard(
                course: activeCourse,
                isFeatured: true,
                onTap: () => _onCourseTap(context, activeCourse),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.rocket_launch_rounded, color: AppColors.primary, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'Begin Your Journey',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You haven’t enrolled in any courses yet. Pick a short skill course below to start learning and get certified!',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: onNavigateToExplore,
                        icon: const Icon(Icons.explore_rounded, size: 16),
                        label: const Text('Browse Courses'),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 28),

            // SECTION 2: EXPLORE COURSES (GridView)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EXPLORE COURSES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                TextButton(
                  onPressed: onNavigateToExplore,
                  child: const Row(
                    children: [
                      Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 14),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Responsive Course Cards Grid / List
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 2 : 1,
                    childAspectRatio: isWide ? 1.25 : 1.35,
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

            const SizedBox(height: 28),

            // SECTION 3: YOUR ACHIEVEMENTS
            Text(
              'YOUR ACHIEVEMENTS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _buildAchievementBadge(
                  context,
                  title: 'First Step',
                  subtitle: 'Enrolled in Course',
                  icon: Icons.emoji_events_rounded,
                  isUnlocked: courseService.enrolledCourses.isNotEmpty,
                ),
                const SizedBox(width: 10),
                _buildAchievementBadge(
                  context,
                  title: 'Module Master',
                  subtitle: '5 Modules Done',
                  icon: Icons.auto_awesome_rounded,
                  isUnlocked: allCourses.any((c) => c.isFullyLearned),
                ),
                const SizedBox(width: 10),
                _buildAchievementBadge(
                  context,
                  title: 'Certified',
                  subtitle: 'Passed Assessment',
                  icon: Icons.workspace_premium_rounded,
                  isUnlocked: completedCount > 0,
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
    required IconData icon,
    required bool isUnlocked,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isUnlocked
              ? (isDark ? AppColors.darkSurface : AppColors.lightSurface)
              : (isDark ? const Color(0xFF161E2E).withOpacity(0.6) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUnlocked
                ? AppColors.accent.withOpacity(0.4)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isUnlocked ? AppColors.accent : (isDark ? AppColors.darkTextMuted : Colors.grey),
              size: 26,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isUnlocked
                    ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                    : (isDark ? AppColors.darkTextMuted : Colors.grey),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                color: isUnlocked
                    ? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                    : (isDark ? AppColors.darkTextMuted : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
