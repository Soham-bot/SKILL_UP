import 'package:flutter/material.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'my_learning_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final CourseService courseService;
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    required this.courseService,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    widget.courseService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    widget.courseService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      HomeScreen(
        courseService: widget.courseService,
        onNavigateToExplore: () => setState(() => _currentIndex = 1),
      ),
      ExploreScreen(courseService: widget.courseService),
      MyLearningScreen(courseService: widget.courseService),
      ProfileScreen(courseService: widget.courseService),
    ];

    // Raw Anti-Design Navigation Bar
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white : AppColors.pitchBlack,
              width: 2.5, // Hard 2.5px brutalist border
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _buildNavItem(0, '// 01_ROOT', Icons.grid_view_rounded),
                _buildNavItem(1, '// 02_NODES', Icons.terminal_rounded),
                _buildNavItem(2, '// 03_BUFFS', Icons.bolt_rounded),
                _buildNavItem(3, '// 04_OPERATOR', Icons.person_sharp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          color: isSelected
              ? (isDark ? AppColors.acidGreen : AppColors.pitchBlack)
              : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? (isDark ? AppColors.pitchBlack : AppColors.acidGreen)
                    : (isDark ? Colors.white : AppColors.pitchBlack),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  color: isSelected
                      ? (isDark ? AppColors.pitchBlack : AppColors.acidGreen)
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
