import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/interceptors/error_interceptor.dart';
import 'package:mocktail/mocktail.dart';

class _MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

DioException _makeDioException({
  required RequestOptions options,
  Response<dynamic>? response,
}) => DioException(
  requestOptions: options,
  response: response,
);

void main() {
  setUpAll(() {
    registerFallbackValue(
      DioException(requestOptions: RequestOptions()),
    );
  });

  group('ErrorInterceptor', () {
    late ErrorInterceptor sut;
    late _MockErrorInterceptorHandler handler;

    setUp(() {
      sut = const ErrorInterceptor();
      handler = _MockErrorInterceptorHandler();
    });

    group('ApiError conversion', () {
      test('rejects with ApiError when response has error_code key', () {
        final options = RequestOptions(path: '/api/v1/users');
        final response = Response<dynamic>(
          requestOptions: options,
          statusCode: 422,
          data: <String, dynamic>{
            'error_code': 'VAL_001',
            'message': 'invalid input',
          },
        );
        final err = _makeDioException(options: options, response: response);

        sut.onError(err, handler);

        final captured =
            verify(() => handler.reject(captureAny())).captured.single
                as DioException;
        expect(captured.error, isA<ApiError>());
        final apiError = captured.error! as ApiError;
        expect(apiError.errorCode, 'VAL_001');
        expect(apiError.message, 'invalid input');
        expect(apiError.statusCode, 422);
      });

      test('uses empty string for message when message key is absent', () {
        final options = RequestOptions(path: '/api/v1/users');
        final response = Response<dynamic>(
          requestOptions: options,
          statusCode: 400,
          data: <String, dynamic>{'error_code': 'AUTH_001'},
        );
        final err = _makeDioException(options: options, response: response);

        sut.onError(err, handler);

        final captured =
            verify(() => handler.reject(captureAny())).captured.single
                as DioException;
        final apiError = captured.error! as ApiError;
        expect(apiError.message, isEmpty);
      });

      test('preserves original response on the re-wrapped DioException', () {
        final options = RequestOptions(path: '/api/v1/users');
        final response = Response<dynamic>(
          requestOptions: options,
          statusCode: 403,
          data: <String, dynamic>{
            'error_code': 'PERM_001',
            'message': 'forbidden',
          },
        );
        final err = _makeDioException(options: options, response: response);

        sut.onError(err, handler);

        final captured =
            verify(() => handler.reject(captureAny())).captured.single
                as DioException;
        expect(captured.response?.statusCode, 403);
      });
    });

    group('pass-through cases', () {
      test('calls next when response data is null', () {
        final options = RequestOptions(path: '/api/v1/users');
        final err = _makeDioException(options: options);

        sut.onError(err, handler);

        verify(() => handler.next(err)).called(1);
        verifyNever(() => handler.reject(any()));
      });

      test('calls next when response data is not a Map', () {
        final options = RequestOptions(path: '/api/v1/users');
        final response = Response<dynamic>(
          requestOptions: options,
          statusCode: 500,
          data: 'plain error string',
        );
        final err = _makeDioException(options: options, response: response);

        sut.onError(err, handler);

        verify(() => handler.next(err)).called(1);
        verifyNever(() => handler.reject(any()));
      });

      test('calls next when Map does not contain error_code key', () {
        final options = RequestOptions(path: '/api/v1/users');
        final response = Response<dynamic>(
          requestOptions: options,
          statusCode: 404,
          data: <String, dynamic>{'detail': 'not found'},
        );
        final err = _makeDioException(options: options, response: response);

        sut.onError(err, handler);

        verify(() => handler.next(err)).called(1);
        verifyNever(() => handler.reject(any()));
      });
    });

    group('ApiError.toString', () {
      test('returns formatted string with error code and message', () {
        const apiError = ApiError(
          errorCode: 'AUTH_001',
          message: 'unauthorized',
          statusCode: 401,
        );
        expect(apiError.toString(), 'ApiError(AUTH_001): unauthorized');
      });
    });
  });
}
