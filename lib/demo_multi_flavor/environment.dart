enum EnvironmentType { dev, prod, staging }

class EnvironmentConfig {
  final EnvironmentType type;
  final String apiBaseUrl;

  EnvironmentConfig.dev()
      : type = EnvironmentType.dev,
        apiBaseUrl = 'https://dev.flutter-flavors.chwe.at';

  EnvironmentConfig.prod()
      : type = EnvironmentType.prod,
        apiBaseUrl = 'https://flutter-flavors.chwe.at';

  EnvironmentConfig.staging()
      : type = EnvironmentType.staging,
        apiBaseUrl = 'https://staging.flutter-flavors.chwe.at';
}
