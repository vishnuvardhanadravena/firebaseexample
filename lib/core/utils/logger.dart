import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../app/flavor/flavor_config.dart';

class AppLogger {
  AppLogger._();

  static bool get _canLog =>
      kDebugMode && FlavorConfig.instance.enableLogs;

  static const _reset = '\x1B[0m';

  static const _red = '\x1B[31m';

  static const _green = '\x1B[32m';

  static const _yellow = '\x1B[33m';

  static const _blue = '\x1B[34m';

  static const _cyan = '\x1B[36m';

  static void debug(String message) {
    if (!_canLog) return;

    debugPrint("$_blue[DEBUG] $message$_reset");
  }

  static void info(String message) {
    if (!_canLog) return;

    debugPrint("$_cyan[INFO] $message$_reset");
  }

  static void success(String message) {
    if (!_canLog) return;

    debugPrint("$_green[SUCCESS] $message$_reset");
  }

  static void warning(String message) {
    if (!_canLog) return;

    debugPrint("$_yellow[WARNING] $message$_reset");
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_canLog) return;

    debugPrint("$_red[ERROR] $message$_reset");

    if (error != null) {
      debugPrint(error.toString());
    }

    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }

  static void json(dynamic data) {
    if (!_canLog) return;

    try {
      const encoder = JsonEncoder.withIndent('  ');

      debugPrint(encoder.convert(data));
    } catch (_) {
      debugPrint(data.toString());
    }
  }

  static void line() {
    if (!_canLog) return;

    debugPrint(
      "══════════════════════════════════════════════════════════════",
    );
  }
}