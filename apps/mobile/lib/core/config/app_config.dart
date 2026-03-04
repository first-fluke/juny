/// {@template app_config}
/// Centralized runtime configuration loaded from `--dart-define`.
/// {@endtemplate}
class AppConfig {
  /// {@macro app_config}
  const AppConfig._();

  /// Base API URL used by Dio clients.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// LiveKit websocket URL used by host/concierge live screens.
  static const String liveKitUrl = String.fromEnvironment('LIVEKIT_URL');
}
