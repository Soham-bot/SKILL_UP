import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../utils/glitch_page_route.dart';
import '../widgets/wireframe_grid_background.dart';
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
      GlitchPageRoute.push(
        context,
        CertificateScreen(
          courseService: widget.courseService,
          quizResult: course.bestResult!,
        ),
      );
    } else {
      GlitchPageRoute.push(
        context,
        LearningHubScreen(
          courseService: widget.courseService,
          courseId: course.id,
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
        title: const Text('// FLEX_RECEIPT // YOUR HUB'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
          unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          indicatorColor: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
          indicatorWeight: 3.5,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontFamily: 'monospace', fontSize: 10.5),
          tabs: [
            Tab(text: 'ENROLLED (${enrolled.length})'),
            Tab(text: 'COOKING (${inProgress.length})'),
            Tab(text: 'CERTIFIED W\'S (${completed.length})'),
          ],
        ),
      ),
      body: WireframeGridBackground(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCourseList(enrolled, '<NOTHING ENROLLED YET 💀>\nGo pick a track from drops to start cooking.'),
            _buildCourseList(inProgress, '<NOTHING COOKING RN>\nPick an enrolled track to begin grinding.'),
            _buildCourseList(completed, '<NO CERTIFICATES YET 💀>\nBeat the 10-MCQ test with ≥ 60% to unlock your big flex.'),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList(List<Course> courses, String emptyMessage) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (courses.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? Colors.white : AppColors.pitchBlack,
              width: 2,
            ),
          ),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700,
              height: 1.45,
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
          physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast,
          ),
          padding: const EdgeInsets.all(14),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 2 : 1,
            childAspectRatio: isWide ? 1.25 : 1.28,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
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
