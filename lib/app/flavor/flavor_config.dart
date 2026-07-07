import 'package:flutter/material.dart';

import 'environment.dart';
import 'flavor.dart';

class FlavorConfig {
  FlavorConfig._();

  static late Flavor _flavor;

  static Flavor get instance => _flavor;

  static void initialize(Environment environment) {
    switch (environment) {
      case Environment.dev:
        _flavor = const Flavor(
          environment: Environment.dev,
          appName: "My App DEV",
          baseUrl: "https://dev-api.company.com",
          enableLogs: true,
          showBanner: true,
          bannerColor: Colors.green,
        );
        break;

      case Environment.stg:
        _flavor = const Flavor(
          environment: Environment.stg,
          appName: "My App STG",
          baseUrl: "https://stg-api.company.com",
          enableLogs: true,
          showBanner: true,
          bannerColor: Colors.orange,
        );
        break;

      case Environment.qa:
        _flavor = const Flavor(
          environment: Environment.qa,
          appName: "My App QA",
          baseUrl: "https://qa-api.company.com",
          enableLogs: true,
          showBanner: true,
          bannerColor: Colors.blue,
        );
        break;

      case Environment.prod:
        _flavor = const Flavor(
          environment: Environment.prod,
          appName: "My App",
          baseUrl: "https://api.company.com",
          enableLogs: false,
          showBanner: false,
          bannerColor: Colors.red,
        );
        break;
    }
  }

  static bool get isDev => instance.environment == Environment.dev;

  static bool get isStg => instance.environment == Environment.stg;

  static bool get isQa => instance.environment == Environment.qa;

  static bool get isProd => instance.environment == Environment.prod;
}