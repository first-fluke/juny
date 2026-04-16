import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/interceptors/auth_interceptor.dart';
import 'package:mocktail/mocktail.dart';

// ---------------------------------------------------------------------------
// Minimal handler doubles
// ---------------------------------------------------------------------------

class _FakeRequestOptions extends Fake implements RequestOptions {}

class _MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class _MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

DioException _buildDioError({
  required RequestOptions options,
  int? statusCode,
}) {
  final response = statusCode != null
      ? Response<dynamic>(
          requestOptions: options,
          statusCode: statusCode,
        )
      : null;
  return DioException(
    requestOptions: options,
    response: response,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeRequestOptions());
    registerFallbackValue(
      DioException(requestOptions: RequestOptions()),
    );
  });

  group('AuthInterceptor', () {
    group('onRequest', () {
      test('adds Authorization header when token is non-empty', () {
        final handler = _MockRequestInterceptorHandler();
        final interceptor = AuthInterceptor(
          tokenGetter: () => 'my_access_token',
          tokenRefresher: () async => null,
          onLogout: () async {},
        );

        final options = RequestOptions(path: '/api/v1/wellness');
        interceptor.onRequest(options, handler);

        expect(
          options.headers['Authorization'],
          'Bearer my_access_token',
        );
        verify(() => handler.next(options)).called(1);
      });

      test('does not add Authorization header when token is empty', () {
        final handler = _MockRequestInterceptorHandler();
        final interceptor = AuthInterceptor(
          tokenGetter: () => '',
          tokenRefresher: () async => null,
          onLogout: () async {},
        );

        final options = RequestOptions(path: '/api/v1/wellness');
        interceptor.onRequest(options, handler);

        expect(options.headers.containsKey('Authorization'), isFalse);
        verify(() => handler.next(options)).called(1);
      });
    });

    group('onError — non-401', () {
      test('passes through errors that are not 401', () async {
        final handler = _MockErrorInterceptorHandler();
        final interceptor = AuthInterceptor(
          tokenGetter: () => 'token',
          tokenRefresher: () async => null,
          onLogout: () async {},
        );

        final options = RequestOptions(path: '/api/v1/wellness');
        final err = _buildDioError(options: options, statusCode: 500);

        await interceptor.onError(err, handler);

        verify(() => handler.next(err)).called(1);
      });

      test('passes through errors with null status code', () async {
        final handler = _MockErrorInterceptorHandler();
        final interceptor = AuthInterceptor(
          tokenGetter: () => 'token',
          tokenRefresher: () async => null,
          onLogout: () async {},
        );

        final options = RequestOptions(path: '/api/v1/wellness');
        final err = _buildDioError(options: options);

        await interceptor.onError(err, handler);

        verify(() => handler.next(err)).called(1);
      });
    });

    group('onError — 401 on auth endpoints (skip refresh)', () {
      test('skips refresh for /auth/login endpoint', () async {
        final handler = _MockErrorInterceptorHandler();
        var refreshCalled = false;
        final interceptor = AuthInterceptor(
          tokenGetter: () => 'token',
          tokenRefresher: () async {
            refreshCalled = true;
            return 'new_token';
          },
          onLogout: () async {},
        );

        final options = RequestOptions(path: '/api/v1/auth/login');
        final err = _buildDioError(options: options, statusCode: 401);

        await interceptor.onError(err, handler);

        expect(refreshCalled, isFalse);
        verify(() => handler.next(err)).called(1);
      });

      test('skips refresh for /auth/refresh endpoint', () async {
        final handler = _MockErrorInterceptorHandler();
        var refreshCalled = false;
        final interceptor = AuthInterceptor(
          tokenGetter: () => 'token',
          tokenRefresher: () async {
            refreshCalled = true;
            return 'new_token';
          },
          onLogout: () async {},
        );

        final options = RequestOptions(path: '/api/v1/auth/refresh');
        final err = _buildDioError(options: options, statusCode: 401);

        await interceptor.onError(err, handler);

        expect(refreshCalled, isFalse);
        verify(() => handler.next(err)).called(1);
      });
    });

    group('onError — 401 with null/empty new token', () {
      test(
        'calls onLogout and passes error when refresher returns null',
        () async {
          final handler = _MockErrorInterceptorHandler();
          var logoutCalled = false;
          final interceptor = AuthInterceptor(
            tokenGetter: () => 'old_token',
            tokenRefresher: () async => null,
            onLogout: () async {
              logoutCalled = true;
            },
          );

          final options = RequestOptions(path: '/api/v1/wellness');
          final err = _buildDioError(options: options, statusCode: 401);

          await interceptor.onError(err, handler);

          expect(logoutCalled, isTrue);
          verify(() => handler.next(err)).called(1);
        },
      );

      test(
        'calls onLogout and passes error when refresher returns empty string',
        () async {
          final handler = _MockErrorInterceptorHandler();
          var logoutCalled = false;
          final interceptor = AuthInterceptor(
            tokenGetter: () => 'old_token',
            tokenRefresher: () async => '',
            onLogout: () async {
              logoutCalled = true;
            },
          );

          final options = RequestOptions(path: '/api/v1/wellness');
          final err = _buildDioError(options: options, statusCode: 401);

          await interceptor.onError(err, handler);

          expect(logoutCalled, isTrue);
          verify(() => handler.next(err)).called(1);
        },
      );
    });

    group('onError — 401 with refresher exception', () {
      test(
        'calls onLogout when refresher throws a generic exception',
        () async {
          final handler = _MockErrorInterceptorHandler();
          var logoutCalled = false;
          final interceptor = AuthInterceptor(
            tokenGetter: () => 'old_token',
            tokenRefresher: () async {
              throw Exception('network failure');
            },
            onLogout: () async {
              logoutCalled = true;
            },
          );

          final options = RequestOptions(path: '/api/v1/wellness');
          final err = _buildDioError(options: options, statusCode: 401);

          await interceptor.onError(err, handler);

          expect(logoutCalled, isTrue);
          verify(() => handler.next(err)).called(1);
        },
      );
    });
  });
}
