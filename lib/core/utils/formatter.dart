import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatter {
  AppFormatter._();

  /// Currency
  static String currency(
    num amount, {
    String symbol = '₹',
    int decimalDigits = 2,
  }) {
    return NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  /// Number
  static String number(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  /// Percentage
  static String percentage(num value) {
    return "${value.toStringAsFixed(2)}%";
  }

  /// Phone Number
  static String phone(String value) {
    if (value.length != 10) return value;

    return "${value.substring(0, 5)} ${value.substring(5)}";
  }

  /// Mask Phone
  static String maskPhone(String value) {
    if (value.length < 10) return value;

    return "${value.substring(0, 2)}******${value.substring(value.length - 2)}";
  }

  /// Mask Email
  static String maskEmail(String email) {
    final parts = email.split("@");

    if (parts.length != 2) return email;

    final name = parts.first;

    if (name.length < 3) return email;

    return "${name.substring(0, 2)}****@${parts.last}";
  }

  /// Capitalize
  static String capitalize(String value) {
    if (value.isEmpty) return value;

    return value[0].toUpperCase() + value.substring(1);
  }

  /// Title Case
  static String titleCase(String value) {
    return value
        .split(" ")
        .map(capitalize)
        .join(" ");
  }
    static String formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

}



class AppInputFormatters {
  AppInputFormatters._();

  static final digitsOnly = FilteringTextInputFormatter.digitsOnly;

  static final decimal = FilteringTextInputFormatter.allow(
    RegExp(r'^\d+\.?\d{0,2}'),
  );

  static final alphabet = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z ]'),
  );

  static final alphaNumeric = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9 ]'),
  );

  static final noSpaces = FilteringTextInputFormatter.deny(
    RegExp(r'\s'),
  );
}