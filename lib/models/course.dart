import 'learning_module.dart';
import 'question.dart';
import 'quiz_result.dart';

enum CourseStatus {
  available,
  enrolled,
  inProgress,
  completed,
}

class Course {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String category;
  final String difficulty;
  final String duration;
  final String iconName;
  final List<String> skillsLearned;
  final List<LearningModule> modules;
  final List<Question> questionBank;
  CourseStatus status;
  double progress;
  QuizResult? bestResult;

  Course({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.iconName,
    required this.skillsLearned,
    required this.modules,
    required this.questionBank,
    this.status = CourseStatus.available,
    this.progress = 0.0,
    this.bestResult,
  });

  int get completedModulesCount => modules.where((m) => m.isCompleted).length;

  bool get isFullyLearned => completedModulesCount == modules.length && modules.isNotEmpty;

  void updateProgress() {
    if (modules.isEmpty) {
      progress = 0.0;
      return;
    }
    progress = completedModulesCount / modules.length;
    if (status != CourseStatus.completed) {
      if (completedModulesCount > 0) {
        status = CourseStatus.inProgress;
      } else if (status == CourseStatus.inProgress && completedModulesCount == 0) {
        status = CourseStatus.enrolled;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'category': category,
      'difficulty': difficulty,
      'duration': duration,
      'iconName': iconName,
      'skillsLearned': skillsLearned,
      'modules': modules.map((m) => m.toJson()).toList(),
      'questionBank': questionBank.map((q) => q.toJson()).toList(),
      'status': status.name,
      'progress': progress,
      'bestResult': bestResult?.toJson(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      fullDescription: json['fullDescription'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      duration: json['duration'] as String,
      iconName: json['iconName'] as String,
      skillsLearned: (json['skillsLearned'] as List<dynamic>).map((e) => e.toString()).toList(),
      modules: (json['modules'] as List<dynamic>)
          .map((m) => LearningModule.fromJson(m as Map<String, dynamic>))
          .toList(),
      questionBank: (json['questionBank'] as List<dynamic>)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      status: CourseStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CourseStatus.available,
      ),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      bestResult: json['bestResult'] != null
          ? QuizResult.fromJson(json['bestResult'] as Map<String, dynamic>)
          : null,
    );
  }
}
