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

    // Neo-Brutalist Navigation Bar with Gen-Z Status Strings
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
              width: 2.5,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                _buildNavItem(0, '// 01_FEED', Icons.grid_view_sharp),
                _buildNavItem(1, '// 02_DROPS', Icons.terminal_sharp),
                _buildNavItem(2, '// FLEX_RECEIPT', Icons.verified_sharp),
                _buildNavItem(3, '// AURA_STATS', Icons.bolt_sharp),
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
                size: 19,
                color: isSelected
                    ? (isDark ? AppColors.pitchBlack : AppColors.acidGreen)
                    : (isDark ? Colors.white : AppColors.pitchBlack),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 0.2,
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
