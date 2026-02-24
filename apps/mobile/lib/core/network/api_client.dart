import 'package:dio/dio.dart';
import 'package:mobile/core/network/interceptors/auth_interceptor.dart';
import 'package:mobile/core/network/interceptors/error_interceptor.dart';

/// {@template api_client_wrapper}
/// Configures a [Dio] instance with auth and error interceptors.
/// {@endtemplate}
class ApiClientWrapper {
  /// {@macro api_client_wrapper}
  ApiClientWrapper({required String Function() tokenGetter, String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? 'http://localhost:8000',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ) {
    _dio.interceptors.addAll([
      AuthInterceptor(tokenGetter: tokenGetter),
      const ErrorInterceptor(),
    ]);
  }

  final Dio _dio;

  /// The underlying [Dio] instance.
  Dio get dio => _dio;
}
