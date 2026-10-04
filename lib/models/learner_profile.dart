import 'package:flutter/material.dart';

class LearnerProfile {
  final String name;
  final ThemeMode themeMode;

  const LearnerProfile({
    required this.name,
    this.themeMode = ThemeMode.system,
  });

  LearnerProfile copyWith({
    String? name,
    ThemeMode? themeMode,
  }) {
    return LearnerProfile(
      name: name ?? this.name,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  /// Validation: trim whitespace; 2–50 characters; letters, spaces, apostrophes, hyphens and dots only.
  static String? validateName(String? raw) {
    if (raw == null) return 'Please enter your full name.';
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return 'Please enter your full name.';
    if (trimmed.length < 2) return 'Name must be at least 2 characters.';
    if (trimmed.length > 50) return 'Name must not exceed 50 characters.';
    final validChars = RegExp(r"^[a-zA-Z\s'\-\.]+$");
    if (!validChars.hasMatch(trimmed)) {
      return 'Only letters, spaces, hyphens, dots, and apostrophes are allowed.';
    }
    return null;
  }

  String get firstName {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Learner';
    final parts = trimmed.split(RegExp(r'\s+'));
    return parts.first;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'themeMode': themeMode.name,
  };

  factory LearnerProfile.fromJson(Map<String, dynamic> json) {
    final modeName = json['themeMode'] as String? ?? 'system';
    final mode = ThemeMode.values.firstWhere(
      (m) => m.name == modeName,
      orElse: () => ThemeMode.system,
    );
    return LearnerProfile(
      name: json['name'] as String? ?? '',
      themeMode: mode,
    );
  }
}
