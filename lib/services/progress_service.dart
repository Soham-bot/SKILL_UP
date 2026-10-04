import 'package:flutter/material.dart';
import '../data/course_repository.dart';
import '../models/course.dart';
import '../models/enums.dart';
import '../models/learner_profile.dart';
import '../models/quiz_result.dart';
import 'storage_service.dart';

class ProgressService extends ChangeNotifier {
  final StorageService _storage;

  late LearnerProfile _profile;
  late Set<String> _enrolledCourses;
  final Map<String, Set<String>> _completedLessons = {};
  final Map<String, QuizResult> _bestResults = {};

  ProgressService(this._storage) {
    _loadAll();
  }

  void _loadAll() {
    _profile = _storage.loadProfile();
    _enrolledCourses = _storage.loadEnrolledCourses();

    for (final course in CourseRepository.allCourses) {
      _completedLessons[course.id] = _storage.loadCompletedLessons(course.id);
      final best = _storage.loadBestResult(course.id);
      if (best != null) {
        _bestResults[course.id] = best;
      }
    }
  }

  // ----------------------------------------------------
  // Profile & Theme
  // ----------------------------------------------------
  LearnerProfile get profile => _profile;
  String get learnerName => _profile.name;
  ThemeMode get themeMode => _profile.themeMode;
  bool get hasProfile => _profile.name.trim().isNotEmpty;

  Future<void> updateName(String newName) async {
    _profile = _profile.copyWith(name: newName.trim());
    await _storage.saveProfile(_profile);
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _profile = _profile.copyWith(themeMode: mode);
    await _storage.saveProfile(_profile);
    notifyListeners();
  }

  // ----------------------------------------------------
  // Enrollment
  // ----------------------------------------------------
  bool isEnrolled(String courseId) => _enrolledCourses.contains(courseId);

  Future<void> enroll(String courseId) async {
    if (!_enrolledCourses.contains(courseId)) {
      _enrolledCourses.add(courseId);
      await _storage.saveEnrolledCourses(_enrolledCourses);
      notifyListeners();
    }
  }

  // ----------------------------------------------------
  // Lessons
  // ----------------------------------------------------
  Set<String> getCompletedLessons(String courseId) {
    return _completedLessons[courseId] ?? <String>{};
  }

  int completedLessonsCount(String courseId) {
    return getCompletedLessons(courseId).length;
  }

  bool isLessonCompleted(String courseId, String lessonId) {
    return getCompletedLessons(courseId).contains(lessonId);
  }

  Future<void> markLessonCompleted(String courseId, String lessonId) async {
    // Auto-enroll if not enrolled
    if (!_enrolledCourses.contains(courseId)) {
      _enrolledCourses.add(courseId);
      await _storage.saveEnrolledCourses(_enrolledCourses);
    }

    final set = _completedLessons.putIfAbsent(courseId, () => <String>{});
    if (!set.contains(lessonId)) {
      set.add(lessonId);
      await _storage.saveCompletedLessons(courseId, set);
      notifyListeners();
    }
  }

  bool isFinalAssessmentUnlocked(String courseId) {
    final course = CourseRepository.getById(courseId);
    if (course == null) return false;
    final completedCount = completedLessonsCount(courseId);
    return completedCount >= course.lessons.length;
  }

  // ----------------------------------------------------
  // Course Status (for chips and home markers)
  // ----------------------------------------------------
  CourseStatus getCourseStatus(String courseId) {
    final best = _bestResults[courseId];
    if (best != null && best.passed) {
      return CourseStatus.completed;
    }
    // Check if attempted but not passed
    final history = _storage.loadAttemptHistory();
    final hasFailedAttempt = history.any((h) => h.courseId == courseId && !h.passed);

    if (hasFailedAttempt && (best == null || !best.passed)) {
      return CourseStatus.attempted;
    }

    if (_enrolledCourses.contains(courseId) || completedLessonsCount(courseId) > 0) {
      return CourseStatus.inProgress;
    }

    return CourseStatus.notStarted;
  }

  // ----------------------------------------------------
  // Quiz Results & Best Scores
  // ----------------------------------------------------
  QuizResult? getBestResult(String courseId) => _bestResults[courseId];

  List<QuizResult> getAllCertificates() {
    return _bestResults.values.where((r) => r.passed).toList();
  }

  Future<void> recordResult(QuizResult result) async {
    await _storage.recordAttempt(result);

    final currentBest = _bestResults[result.courseId];
    if (result.passed) {
      if (currentBest == null || result.score >= currentBest.score) {
        _bestResults[result.courseId] = result;
        await _storage.saveBestResult(result.courseId, result);
      }
    } else if (currentBest == null) {
      // Still store as latest attempted result if none exists
      _bestResults[result.courseId] = result;
      await _storage.saveBestResult(result.courseId, result);
    }

    notifyListeners();
  }

  // ----------------------------------------------------
  // Continue Learning Active Course
  // ----------------------------------------------------
  Course? getActiveCourse() {
    for (final course in CourseRepository.allCourses) {
      final status = getCourseStatus(course.id);
      if (status == CourseStatus.inProgress || status == CourseStatus.attempted) {
        return course;
      }
    }
    return null;
  }

  // ----------------------------------------------------
  // Reset
  // ----------------------------------------------------
  Future<void> resetAll({bool keepProfileName = true}) async {
    await _storage.resetAll(keepProfileName: keepProfileName);
    _enrolledCourses.clear();
    _completedLessons.clear();
    _bestResults.clear();
    if (!keepProfileName) {
      _profile = const LearnerProfile(name: '', themeMode: ThemeMode.system);
    }
    notifyListeners();
  }
}
