enum Environment { dev, qa, prod }

extension EnvironmentExtension on Environment {
  String get name {
    switch (this) {
      case Environment.dev:
        return "DEV";

      case Environment.qa:
        return "QA";

      case Environment.prod:
        return "PROD";
    }
  }
}
