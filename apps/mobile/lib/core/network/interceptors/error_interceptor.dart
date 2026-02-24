import 'package:dio/dio.dart';

/// {@template api_error}
/// Structured error from the API with an error code.
/// {@endtemplate}
class ApiError implements Exception {
  /// {@macro api_error}
  const ApiError({
    required this.errorCode,
    required this.message,
    this.statusCode,
  });

  /// The backend error code (e.g. 'AUTH_001').
  final String errorCode;

  /// The error message from the backend.
  final String message;

  /// The HTTP status code.
  final int? statusCode;

  @override
  String toString() => 'ApiError($errorCode): $message';
}

/// {@template error_interceptor}
/// Extracts structured error codes from API error responses.
/// {@endtemplate}
class ErrorInterceptor extends Interceptor {
  /// {@macro error_interceptor}
  const ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;
    if (data is Map<String, dynamic> && data.containsKey('error_code')) {
      final apiError = ApiError(
        errorCode: data['error_code'] as String,
        message: data['message'] as String? ?? '',
        statusCode: err.response?.statusCode,
      );
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: apiError,
        ),
      );
      return;
    }
    handler.next(err);
  }
}
