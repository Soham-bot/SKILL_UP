import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../widgets/course_card.dart';
import 'learning_hub_screen.dart';
import 'certificate_screen.dart';

class MyLearningScreen extends StatefulWidget {
  final CourseService courseService;

  const MyLearningScreen({super.key, required this.courseService});

  @override
  State<MyLearningScreen> createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends State<MyLearningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onCourseTap(Course course) {
    if (course.status == CourseStatus.completed && course.bestResult != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CertificateScreen(
            courseService: widget.courseService,
            quizResult: course.bestResult!,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LearningHubScreen(
            courseService: widget.courseService,
            courseId: course.id,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enrolled = widget.courseService.enrolledCourses;
    final inProgress = widget.courseService.inProgressCourses;
    final completed = widget.courseService.completedCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Learning Hub'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'All Enrolled (${enrolled.length})'),
            Tab(text: 'In Progress (${inProgress.length})'),
            Tab(text: 'Completed (${completed.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCourseList(enrolled, 'No enrolled courses yet.\nExplore our catalog and enroll for free!'),
          _buildCourseList(inProgress, 'No courses currently in progress.\nPick a course to start learning!'),
          _buildCourseList(completed, 'No completed courses yet.\nFinish all 5 modules and score ≥ 60% to get certified!'),
        ],
      ),
    );
  }

  Widget _buildCourseList(List<Course> courses, String emptyMessage) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (courses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_outlined,
                size: 54,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              const SizedBox(height: 16),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 2 : 1,
            childAspectRatio: isWide ? 1.25 : 1.35,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseCard(
              course: course,
              onTap: () => _onCourseTap(course),
            );
          },
        );
      },
    );
  }
}
