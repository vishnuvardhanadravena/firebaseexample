enum Environment { dev, stg, qa, prod }

extension EnvironmentExtension on Environment {
  String get name {
    switch (this) {
      case Environment.dev:
        return "DEV";

      case Environment.stg:
        return "STG";

      case Environment.qa:
        return "QA";

      case Environment.prod:
        return "PROD";
    }
  }
}
