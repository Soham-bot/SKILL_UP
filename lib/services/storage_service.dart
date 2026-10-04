import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/learner_profile.dart';
import '../models/quiz_result.dart';

class StorageService {
  static const String _keyProfileName = 'skillup_profile_name';
  static const String _keyThemeMode = 'skillup_theme_mode';
  static const String _keyEnrolledCourses = 'skillup_enrolled_courses';
  static const String _keyLessonPrefix = 'skillup_completed_lessons_';
  static const String _keyBestResultPrefix = 'skillup_best_result_';
  static const String _keyAttemptHistory = 'skillup_attempt_history';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // ----------------------------------------------------
  // Profile & Theme
  // ----------------------------------------------------
  LearnerProfile loadProfile() {
    try {
      final name = _prefs.getString(_keyProfileName) ?? '';
      final modeName = _prefs.getString(_keyThemeMode) ?? 'system';
      final mode = ThemeMode.values.firstWhere(
        (m) => m.name == modeName,
        orElse: () => ThemeMode.system,
      );
      return LearnerProfile(name: name, themeMode: mode);
    } catch (_) {
      return const LearnerProfile(name: '', themeMode: ThemeMode.system);
    }
  }

  Future<void> saveProfile(LearnerProfile profile) async {
    await _prefs.setString(_keyProfileName, profile.name);
    await _prefs.setString(_keyThemeMode, profile.themeMode.name);
  }

  // ----------------------------------------------------
  // Enrollment
  // ----------------------------------------------------
  Set<String> loadEnrolledCourses() {
    try {
      final list = _prefs.getStringList(_keyEnrolledCourses);
      return list?.toSet() ?? <String>{};
    } catch (_) {
      return <String>{};
    }
  }

  Future<void> saveEnrolledCourses(Set<String> courseIds) async {
    await _prefs.setStringList(_keyEnrolledCourses, courseIds.toList());
  }

  // ----------------------------------------------------
  // Lessons Completion
  // ----------------------------------------------------
  Set<String> loadCompletedLessons(String courseId) {
    try {
      final list = _prefs.getStringList('$_keyLessonPrefix$courseId');
      return list?.toSet() ?? <String>{};
    } catch (_) {
      return <String>{};
    }
  }

  Future<void> saveCompletedLessons(String courseId, Set<String> lessonIds) async {
    await _prefs.setStringList('$_keyLessonPrefix$courseId', lessonIds.toList());
  }

  // ----------------------------------------------------
  // Best Results (Certificates)
  // ----------------------------------------------------
  QuizResult? loadBestResult(String courseId) {
    try {
      final raw = _prefs.getString('$_keyBestResultPrefix$courseId');
      if (raw == null || raw.isEmpty) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return QuizResult.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Map<String, QuizResult> loadAllBestResults(List<String> courseIds) {
    final results = <String, QuizResult>{};
    for (final id in courseIds) {
      final res = loadBestResult(id);
      if (res != null) {
        results[id] = res;
      }
    }
    return results;
  }

  Future<void> saveBestResult(String courseId, QuizResult result) async {
    final raw = jsonEncode(result.toJson());
    await _prefs.setString('$_keyBestResultPrefix$courseId', raw);
  }

  // ----------------------------------------------------
  // Attempt History (Last 10 attempts)
  // ----------------------------------------------------
  List<QuizResult> loadAttemptHistory() {
    try {
      final list = _prefs.getStringList(_keyAttemptHistory);
      if (list == null) return [];
      return list.map((str) {
        try {
          return QuizResult.fromJson(jsonDecode(str) as Map<String, dynamic>);
        } catch (_) {
          return null;
        }
      }).whereType<QuizResult>().toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> recordAttempt(QuizResult result) async {
    try {
      final history = loadAttemptHistory();
      history.insert(0, result);
      // Keep only last 10 attempts
      final trimmed = history.take(10).map((r) => jsonEncode(r.toJson())).toList();
      await _prefs.setStringList(_keyAttemptHistory, trimmed);
    } catch (_) {
      // Fail gracefully
    }
  }

  // ----------------------------------------------------
  // Reset
  // ----------------------------------------------------
  Future<void> resetAll({bool keepProfileName = true}) async {
    final profile = loadProfile();
    await _prefs.clear();
    if (keepProfileName && profile.name.isNotEmpty) {
      await _prefs.setString(_keyProfileName, profile.name);
    }
  }
}
