import 'package:flutter/material.dart';
import '../data/course_data.dart';
import '../models/course.dart';
import '../models/learner_profile.dart';
import '../models/quiz_result.dart';
import 'storage_service.dart';

class CourseService extends ChangeNotifier {
  List<Course> _courses = [];
  LearnerProfile? _profile;
  bool _isDarkMode = true; // Modern sleek dark mode by default
  bool _isLoading = true;

  List<Course> get courses => _courses;
  LearnerProfile? get profile => _profile;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  // Filtered lists for the Home and My Learning tabs
  List<Course> get enrolledCourses =>
      _courses.where((c) => c.status != CourseStatus.available).toList();

  List<Course> get inProgressCourses => _courses
      .where((c) =>
          c.status == CourseStatus.inProgress ||
          (c.status == CourseStatus.enrolled && c.progress > 0 && c.status != CourseStatus.completed))
      .toList();

  List<Course> get completedCourses =>
      _courses.where((c) => c.status == CourseStatus.completed).toList();

  List<Course> get availableCourses =>
      _courses.where((c) => c.status == CourseStatus.available).toList();

  // Initialization
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // 1. Load Profile
    _profile = await StorageService.getProfile();

    // 2. Load Theme Mode
    _isDarkMode = await StorageService.getDarkMode();

    // 3. Load Courses
    final saved = await StorageService.getSavedCourses();
    if (saved != null && saved.isNotEmpty) {
      _courses = saved;
    } else {
      _courses = CourseData.getInitialCourses();
      await StorageService.saveCourses(_courses);
    }

    _isLoading = false;
    notifyListeners();
  }

  // Learner Profile Actions
  Future<void> saveProfile(LearnerProfile profile) async {
    _profile = profile;
    await StorageService.saveProfile(profile);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.saveDarkMode(_isDarkMode);
    notifyListeners();
  }

  // Course Enrollment State Machine
  Future<void> enroll(String courseId) async {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      final course = _courses[index];
      if (course.status == CourseStatus.available) {
        course.status = CourseStatus.enrolled;
        _addXp(25); // Gamification reward for enrolling
        await StorageService.saveCourses(_courses);
        notifyListeners();
      }
    }
  }

  // Learning Module Progression
  Future<void> completeModule(String courseId, String moduleId) async {
    final courseIndex = _courses.indexWhere((c) => c.id == courseId);
    if (courseIndex != -1) {
      final course = _courses[courseIndex];
      final moduleIndex = course.modules.indexWhere((m) => m.id == moduleId);
      if (moduleIndex != -1) {
        final module = course.modules[moduleIndex];
        if (!module.isCompleted) {
          module.isCompleted = true;
          course.updateProgress();
          _addXp(30); // Gamification reward for finishing module
          await StorageService.saveCourses(_courses);
          notifyListeners();
        }
      }
    }
  }

  // Assessment & Certification
  Future<void> recordQuizResult(String courseId, QuizResult result) async {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      final course = _courses[index];
      if (result.passed) {
        course.status = CourseStatus.completed;
        if (course.bestResult == null || result.percentage >= course.bestResult!.percentage) {
          course.bestResult = result;
        }
        _addXp(150); // Big XP reward for earning certificate
      } else {
        // Record attempt even if failed, but don't overwrite a previous passing certificate
        course.bestResult ??= result;
      }
      await StorageService.saveCourses(_courses);
      notifyListeners();
    }
  }

  Course? getCourseById(String id) {
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void _addXp(int amount) {
    if (_profile != null) {
      _profile!.xp += amount;
      StorageService.saveProfile(_profile!);
    }
  }
}
