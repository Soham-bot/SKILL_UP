import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/main.dart';
import 'package:skillup/services/course_service.dart';

void main() {
  testWidgets('TC01 & TC02: SkillUp launches and displays branding and setup/home flow',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final courseService = CourseService();
    await courseService.initialize();

    await tester.pumpWidget(SkillUpApp(courseService: courseService));
    await tester.pumpAndSettle();

    // Verify SkillUp brand text and tagline presence
    expect(find.text('SKILLUP'), findsWidgets);
    expect(find.text('LEARN. LEVEL UP. GET CERTIFIED.'), findsWidgets);
  });
}
