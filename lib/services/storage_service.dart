import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/learner_profile.dart';
import '../models/course.dart';

class StorageService {
  static const String _keyProfile = 'skillup_profile';
  static const String _keyCourses = 'skillup_courses_state';
  static const String _keyDarkMode = 'skillup_dark_mode';

  // PROFILE PERSISTENCE
  static Future<bool> saveProfile(LearnerProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(profile.toJson());
    return prefs.setString(_keyProfile, jsonStr);
  }

  static Future<LearnerProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyProfile);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return LearnerProfile.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  // COURSE PROGRESS PERSISTENCE
  static Future<bool> saveCourses(List<Course> courses) async {
    final prefs = await SharedPreferences.getInstance();
    final list = courses.map((c) => c.toJson()).toList();
    final jsonStr = jsonEncode(list);
    return prefs.setString(_keyCourses, jsonStr);
  }

  static Future<List<Course>?> getSavedCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyCourses);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((item) => Course.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  // THEME PREFERENCE
  static Future<bool> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_keyDarkMode, isDark);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? true; // Default to sleek dark mode
  }
}
