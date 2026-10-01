import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';
import 'learning_hub_screen.dart';
import 'certificate_screen.dart';

class ExploreScreen extends StatefulWidget {
  final CourseService courseService;

  const ExploreScreen({super.key, required this.courseService});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Mobile Development',
    'Programming & AI',
    'Web Engineering',
    'Security & Systems',
  ];

  @override
  void dispose() {
    _searchController.dispose();
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
    } else if (course.status == CourseStatus.inProgress || course.status == CourseStatus.enrolled) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LearningHubScreen(
            courseService: widget.courseService,
            courseId: course.id,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CourseDetailScreen(
            courseService: widget.courseService,
            course: course,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allCourses = widget.courseService.courses;

    final filteredCourses = allCourses.where((c) {
      final matchesCat = _selectedCategory == 'All' || c.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.shortDescription.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.skillsLearned.any((s) => s.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCat && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('// 02_EXPLORE_NODES'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Brutalist Search Terminal Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                      offset: const Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  decoration: InputDecoration(
                    hintText: 'QUERY: Flutter, Python, Security...',
                    hintStyle: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurface : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: isDark ? Colors.white : AppColors.pitchBlack,
                        width: 2.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: isDark ? Colors.white : AppColors.pitchBlack,
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Category Filter Buttons
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.acidGreen : AppColors.pitchBlack)
                            : (isDark ? const Color(0xFF161616) : Colors.white),
                        border: Border.all(
                          color: isDark ? Colors.white : AppColors.pitchBlack,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: isDark ? Colors.white.withValues(alpha: 0.3) : AppColors.pitchBlack,
                                  offset: const Offset(2, 2),
                                  blurRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          cat.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: isSelected
                                ? (isDark ? AppColors.pitchBlack : AppColors.acidGreen)
                                : (isDark ? Colors.white : AppColors.pitchBlack),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Results Counter Tag
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '// MATCHES: ${filteredCourses.length} NODES_FOUND',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Courses Grid
            Expanded(
              child: filteredCourses.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? Colors.white : AppColors.pitchBlack,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '// NO_NODES_MATCH_QUERY',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: isDark ? AppColors.glitchCrimson : AppColors.pitchBlack,
                          ),
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 600;
                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isWide ? 2 : 1,
                            childAspectRatio: isWide ? 1.25 : 1.28,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: filteredCourses.length,
                          itemBuilder: (context, index) {
                            final course = filteredCourses[index];
                            return CourseCard(
                              course: course,
                              onTap: () => _onCourseTap(course),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
