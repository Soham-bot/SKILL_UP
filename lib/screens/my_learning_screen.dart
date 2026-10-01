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
        title: const Text('// 03_BUFFS // MY_LEARNING'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
          unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          indicatorColor: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
          indicatorWeight: 3.5,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontFamily: 'monospace', fontSize: 11),
          tabs: [
            Tab(text: 'ENROLLED (${enrolled.length})'),
            Tab(text: 'IN_FLIGHT (${inProgress.length})'),
            Tab(text: 'CERTIFIED (${completed.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCourseList(enrolled, '// NO_ENROLLED_NODES_IN_BUFFER\nBrowse nodes to initialize enrollment.'),
          _buildCourseList(inProgress, '// NO_NODES_IN_FLIGHT\nExecute an enrolled node to begin.'),
          _buildCourseList(completed, '// NO_CERTIFICATES_LOGGED\nPass a 10-MCQ assessment with ≥ 60% to get certified.'),
        ],
      ),
    );
  }

  Widget _buildCourseList(List<Course> courses, String emptyMessage) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (courses.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? const Color(0xFF333333) : const Color(0xFFCCCCCC),
              width: 2,
            ),
          ),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700,
              height: 1.5,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 2 : 1,
            childAspectRatio: isWide ? 1.25 : 1.28,
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
