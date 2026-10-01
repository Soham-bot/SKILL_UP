class LearnerProfile {
  final String name;
  final String? email;
  final String? phone;
  int xp;
  int streakDays;
  DateTime lastActiveDate;

  LearnerProfile({
    required this.name,
    this.email,
    this.phone,
    this.xp = 0,
    this.streakDays = 1,
    DateTime? lastActiveDate,
  }) : lastActiveDate = lastActiveDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'xp': xp,
      'streakDays': streakDays,
      'lastActiveDate': lastActiveDate.toIso8601String(),
    };
  }

  factory LearnerProfile.fromJson(Map<String, dynamic> json) {
    return LearnerProfile(
      name: json['name'] as String? ?? 'Learner',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 1,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.tryParse(json['lastActiveDate'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  LearnerProfile copyWith({
    String? name,
    String? email,
    String? phone,
    int? xp,
    int? streakDays,
    DateTime? lastActiveDate,
  }) {
    return LearnerProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      xp: xp ?? this.xp,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}
