import 'dart:math';

class CertificateUtils {
  static final _random = Random();

  static String generateCertificateId(String courseId) {
    String code = 'GEN';
    final lower = courseId.toLowerCase();
    if (lower.contains('flutter')) {
      code = 'FLT';
    } else if (lower.contains('python')) {
      code = 'PYT';
    } else if (lower.contains('web')) {
      code = 'WEB';
    } else if (lower.contains('cyber') || lower.contains('security')) {
      code = 'SEC';
    }

    final year = DateTime.now().year;
    final randomNum = 1000 + _random.nextInt(9000); // 4-digit number
    return 'SKL-$code-$year-$randomNum';
  }

  static String formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    return '$day $month $year';
  }

  static String formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
