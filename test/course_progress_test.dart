import 'package:flutter_test/flutter_test.dart';
import 'package:skillup/data/course_data.dart';
import 'package:skillup/models/course.dart';

void main() {
  group('Course Progression & State Machine Tests', () {
    test('TC06, TC08 & TC09: Module completion updates progress and state machine', () {
      final course = CourseData.getInitialCourses().firstWhere((c) => c.id == 'course_flutter');

      // Initial state: Available, 0% progress
      expect(course.status, equals(CourseStatus.available));
      expect(course.progress, equals(0.0));
      expect(course.completedModulesCount, equals(0));
      expect(course.isFullyLearned, isFalse);

      // Simulate enrollment
      course.status = CourseStatus.enrolled;
      expect(course.status, equals(CourseStatus.enrolled));

      // Complete Module 1 -> 20%
      course.modules[0].isCompleted = true;
      course.updateProgress();
      expect(course.completedModulesCount, equals(1));
      expect(course.progress, equals(0.2));
      expect(course.status, equals(CourseStatus.inProgress));

      // Complete Module 2, 3, 4 -> 80%
      course.modules[1].isCompleted = true;
      course.modules[2].isCompleted = true;
      course.modules[3].isCompleted = true;
      course.updateProgress();
      expect(course.completedModulesCount, equals(4));
      expect(course.progress, equals(0.8));
      expect(course.isFullyLearned, isFalse);

      // Complete Module 5 -> 100%
      course.modules[4].isCompleted = true;
      course.updateProgress();
      expect(course.completedModulesCount, equals(5));
      expect(course.progress, equals(1.0));
      expect(course.isFullyLearned, isTrue);
    });

    test('All 4 courses have exactly 5 modules and >= 15 questions', () {
      final courses = CourseData.getInitialCourses();
      expect(courses.length, equals(4));

      for (final c in courses) {
        expect(c.modules.length, equals(5), reason: '${c.title} must have exactly 5 modules');
        expect(c.questionBank.length, greaterThanOrEqualTo(15),
            reason: '${c.title} must have a large question bank');
      }
    });
  });
}
