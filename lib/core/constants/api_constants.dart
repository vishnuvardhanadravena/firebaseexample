import 'package:flavor/app/flavor/environment.dart';
import 'package:flavor/app/flavor/flavor_config.dart';

class ApiConstants {
  ApiConstants._();
  static const Duration connectTimeout = Duration(seconds: 30);

  static const Duration receiveTimeout = Duration(seconds: 30);

  static const Duration sendTimeout = Duration(seconds: 30);  
  static String get baseUrl {
    switch (FlavorConfig.instance.environment) {
      case Environment.dev:
        return "https://dev-api.company.com";
      case Environment.qa:
        return "https://qa-api.company.com";

      case Environment.prod:
        return "https://api.company.com";
    }
  }

  static const login = "/login";
  static const signup = "/signup";
  static const profile = "/profile";
  static const refreshToken = "/refresh-token";
}
