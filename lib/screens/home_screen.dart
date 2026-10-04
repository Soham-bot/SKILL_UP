import 'package:flutter/material.dart';
import '../data/course_repository.dart';
import '../models/course.dart';
import '../services/progress_scope.dart';
import '../widgets/course_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/responsive_container.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _categories {
    final cats = CourseRepository.allCourses.map((c) => c.category).toSet().toList();
    return ['All', ...cats];
  }

  List<Course> get _filteredCourses {
    return CourseRepository.allCourses.where((course) {
      final matchesCategory =
          _selectedCategory == 'All' || course.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery) ||
          course.description.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'All';
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = ProgressScope.of(context);
    final activeCourse = progress.getActiveCourse();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${progress.profile.firstName}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'Select a course to build certified mastery',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.65),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              tooltip: 'Learner Profile',
              onPressed: () {
                if (widget.onNavigateToTab != null) {
                  widget.onNavigateToTab!(2); // Switch to Profile tab
                } else {
                  Navigator.of(context).pushNamed('/profile');
                }
              },
              icon: CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  progress.profile.firstName.isNotEmpty
                      ? progress.profile.firstName[0].toUpperCase()
                      : 'L',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;
          final isExpanded = constraints.maxWidth >= 1000;
          final crossAxisCount = isExpanded ? 3 : (isWide ? 2 : 1);

          return ResponsiveContainer(
            maxWidth: 1100,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: CustomScrollView(
              slivers: [
                // Continue Learning Card (if course is in progress)
                if (activeCourse != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildContinueLearningCard(
                        context,
                        activeCourse,
                        progress.completedLessonsCount(activeCourse.id),
                        activeCourse.lessons.length,
                      ),
                    ),
                  ),

                // Search Field
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search courses and skills...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                // Category Filter Chips
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Course Catalog Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Available Certifications',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_filteredCourses.length} courses',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Empty State or Course List
                if (_filteredCourses.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.search_off_outlined,
                      title: 'No courses found',
                      message:
                          'We could not find any courses matching "$_searchQuery". Try adjusting your search term or category filter.',
                      actionLabel: 'Clear filters',
                      onAction: _clearFilters,
                    ),
                  )
                else if (crossAxisCount == 1)
                  // Phone ListView (lazy builder)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final course = _filteredCourses[index];
                        final status = progress.getCourseStatus(course.id);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CourseCard(
                            course: course,
                            status: status,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/course-detail',
                                arguments: course.id,
                              );
                            },
                          ),
                        );
                      },
                      childCount: _filteredCourses.length,
                    ),
                  )
                else
                  // Tablet / Desktop GridView (lazy builder)
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      mainAxisExtent: 260,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final course = _filteredCourses[index];
                        final status = progress.getCourseStatus(course.id);
                        return CourseCard(
                          course: course,
                          status: status,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/course-detail',
                              arguments: course.id,
                            );
                          },
                        );
                      },
                      childCount: _filteredCourses.length,
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContinueLearningCard(
    BuildContext context,
    Course course,
    int completed,
    int total,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progressFraction = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

    return Card(
      color: colorScheme.primaryContainer.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.primary.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.play_circle_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'CONTINUE LEARNING',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              course.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressFraction,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completed of $total lessons completed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/learning-path',
                      arguments: course.id,
                    );
                  },
                  child: const Text('Resume'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
