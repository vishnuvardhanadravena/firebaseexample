import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  /// ===============================
  /// Format Date
  /// ===============================

  static String format(
    DateTime date, {
    String pattern = 'dd MMM yyyy',
  }) {
    return DateFormat(pattern).format(date);
  }

  static String date(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String time(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String dateTime(DateTime date) {
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }

  static String iso(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// ===============================
  /// Relative
  /// ===============================

  static bool isToday(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday =
        DateTime.now().subtract(const Duration(days: 1));

    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow =
        DateTime.now().add(const Duration(days: 1));

    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// ===============================
  /// Difference
  /// ===============================

  static int daysBetween(
    DateTime from,
    DateTime to,
  ) {
    return to.difference(from).inDays;
  }

  static int hoursBetween(
    DateTime from,
    DateTime to,
  ) {
    return to.difference(from).inHours;
  }

  static int minutesBetween(
    DateTime from,
    DateTime to,
  ) {
    return to.difference(from).inMinutes;
  }

  /// ===============================
  /// Convert
  /// ===============================

  static DateTime? parse(String value) {
    return DateTime.tryParse(value);
  }

  static String now() {
    return DateTime.now().toIso8601String();
  }

  /// ===============================
  /// Age
  /// ===============================

  static int calculateAge(DateTime dob) {
    final today = DateTime.now();

    int age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month &&
            today.day < dob.day)) {
      age--;
    }

    return age;
  }
}