/// {@template app_config}
/// Centralized runtime configuration loaded from `--dart-define`.
/// {@endtemplate}
class AppConfig {
  /// {@macro app_config}
  const AppConfig._();

  /// Base API URL used by Dio clients.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8200',
  );

  /// LiveKit websocket URL used by host/concierge live screens.
  static const String liveKitUrl = String.fromEnvironment('LIVEKIT_URL');

  /// Google Maps API key for map rendering in navigation screens.
  ///
  /// Inject at build time via `--dart-define=GOOGLE_MAPS_API_KEY=<key>`.
  /// When empty the map tile area is replaced with a placeholder.
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
  );
}
