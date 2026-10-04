enum Difficulty {
  beginner,
  intermediate,
  advanced;

  String get label {
    switch (this) {
      case Difficulty.beginner:
        return 'Beginner';
      case Difficulty.intermediate:
        return 'Intermediate';
      case Difficulty.advanced:
        return 'Advanced';
    }
  }
}

enum CourseStatus {
  notStarted,
  inProgress,
  attempted,
  completed;

  String get label {
    switch (this) {
      case CourseStatus.notStarted:
        return 'Not started';
      case CourseStatus.inProgress:
        return 'In progress';
      case CourseStatus.attempted:
        return 'Attempted';
      case CourseStatus.completed:
        return 'Completed';
    }
  }
}
