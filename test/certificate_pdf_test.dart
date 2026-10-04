import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:skillup/data/course_repository.dart';
import 'package:skillup/services/certificate_pdf_service.dart';
import 'package:skillup/services/quiz_service.dart';

void main() {
  test('CertificatePdfService.build(result) returns non-empty bytes starting with %PDF', () async {
    final course = CourseRepository.allCourses.first;
    final questions = course.questionBank.take(10).toList();
    final result = QuizService.evaluate(
      course: course,
      questions: questions,
      answers: {for (int i = 0; i < 10; i++) i: questions[i].correctIndex},
      learnerName: 'Dr. Jane Hopper',
    );

    final pdfBytes = await CertificatePdfService.build(result);

    expect(pdfBytes, isNotEmpty);
    expect(pdfBytes.length, greaterThan(1000));

    // Verify first 4 bytes are %PDF in ASCII (0x25, 0x50, 0x44, 0x46)
    final header = ascii.decode(pdfBytes.sublist(0, 4));
    expect(header, '%PDF');
  });
}
