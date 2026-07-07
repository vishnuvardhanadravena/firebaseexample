import 'package:flutter/material.dart';

import 'environment.dart';

class Flavor {
  const Flavor({
    required this.environment,
    required this.appName,
    required this.baseUrl,
    required this.enableLogs,
    required this.showBanner,
    required this.bannerColor,
  });

  final Environment environment;

  final String appName;

  final String baseUrl;

  final bool enableLogs;

  final bool showBanner;

  final Color bannerColor;
}