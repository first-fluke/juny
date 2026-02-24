import 'package:dio/dio.dart';

/// {@template auth_interceptor}
/// Attaches the JWT access token to every outgoing request.
/// {@endtemplate}
class AuthInterceptor extends Interceptor {
  /// {@macro auth_interceptor}
  AuthInterceptor({required String Function() tokenGetter})
    : _tokenGetter = tokenGetter;

  final String Function() _tokenGetter;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenGetter();
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
