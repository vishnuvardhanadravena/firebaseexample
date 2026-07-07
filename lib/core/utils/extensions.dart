import 'package:flutter/material.dart';

///==============================
/// String Extensions
///==============================
extension StringExtensions on String {
  bool get isEmail {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(trim());
  }

  bool get isPhone {
    return RegExp(r'^[0-9]{10}$').hasMatch(trim());
  }

  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  bool get isUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }

  String get capitalize {
    if (isEmpty) return this;

    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    return split(' ')
        .map((e) => e.capitalize)
        .join(' ');
  }

  String get removeSpaces {
    return replaceAll(' ', '');
  }
}

///==============================
/// BuildContext Extensions
///==============================
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colors => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.sizeOf(this);

  double get width => MediaQuery.sizeOf(this).width;

  double get height => MediaQuery.sizeOf(this).height;

  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  Future<T?> push<T>(Widget page) {
    return Navigator.push(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void pop<T>([T? result]) {
    Navigator.pop(this, result);
  }
}

///==============================
/// Number Extensions
///==============================
extension NumExtensions on num {
  SizedBox get hSpace => SizedBox(height: toDouble());

  SizedBox get wSpace => SizedBox(width: toDouble());

  Duration get milliseconds =>
      Duration(milliseconds: toInt());

  Duration get seconds =>
      Duration(seconds: toInt());
}

///==============================
/// DateTime Extensions
///==============================
extension DateTimeExtensions on DateTime {
  String get ddMMyyyy {
    return "${day.toString().padLeft(2, '0')}/"
        "${month.toString().padLeft(2, '0')}/"
        "$year";
  }

  String get yyyyMMdd {
    return "$year-"
        "${month.toString().padLeft(2, '0')}-"
        "${day.toString().padLeft(2, '0')}";
  }

  bool get isToday {
    final now = DateTime.now();

    return day == now.day &&
        month == now.month &&
        year == now.year;
  }
}