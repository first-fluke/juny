import 'package:dio/dio.dart';

/// Callback to refresh the access token. Returns the new token or null.
typedef TokenRefresher = Future<String?> Function();

/// Callback to handle logout when refresh fails.
typedef LogoutCallback = Future<void> Function();

/// {@template auth_interceptor}
/// Attaches the JWT access token to every outgoing request
/// and automatically refreshes on 401 responses.
///
/// Uses [QueuedInterceptorsWrapper] to serialize concurrent 401 handling,
/// preventing duplicate refresh calls.
/// {@endtemplate}
class AuthInterceptor extends QueuedInterceptorsWrapper {
  /// {@macro auth_interceptor}
  AuthInterceptor({
    required String Function() tokenGetter,
    required TokenRefresher tokenRefresher,
    required LogoutCallback onLogout,
  }) : _tokenGetter = tokenGetter,
       _tokenRefresher = tokenRefresher,
       _onLogout = onLogout;

  final String Function() _tokenGetter;
  final TokenRefresher _tokenRefresher;
  final LogoutCallback _onLogout;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenGetter();
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Skip refresh for auth endpoints themselves
    final path = err.requestOptions.path;
    if (path.contains('/auth/login') || path.contains('/auth/refresh')) {
      handler.next(err);
      return;
    }

    try {
      final newToken = await _tokenRefresher();
      if (newToken == null || newToken.isEmpty) {
        await _onLogout();
        handler.next(err);
        return;
      }

      // Retry the original request with the new token
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newToken';

      final response = await Dio(
        BaseOptions(baseUrl: options.baseUrl),
      ).fetch<dynamic>(options);

      handler.resolve(response);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    } on Exception {
      await _onLogout();
      handler.next(err);
    }
  }
}
