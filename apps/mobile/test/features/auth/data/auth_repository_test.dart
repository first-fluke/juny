import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/data/secure_token_storage.dart';
import 'package:mobile/features/auth/domain/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthenticationService extends Mock
    implements AuthenticationService {}

class _MockSecureTokenStorage extends Mock implements SecureTokenStorage {}

/// Builds a minimal JWT with a [role] claim in the payload.
String _buildJwt(String role) {
  final header = base64Url.encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
  final payload = base64Url.encode(
    utf8.encode('{"sub":"user-id","role":"$role","exp":9999999999}'),
  );
  return '$header.$payload.signature';
}

void main() {
  late _MockAuthenticationService mockAuthService;
  late _MockSecureTokenStorage mockTokenStorage;
  late AuthRepository sut;

  setUp(() {
    mockAuthService = _MockAuthenticationService();
    mockTokenStorage = _MockSecureTokenStorage();
    sut = AuthRepository(
      authService: mockAuthService,
      tokenStorage: mockTokenStorage,
    );

    registerFallbackValue(
      const OAuthLoginRequest(
        provider: OAuthLoginRequestProvider.google,
        accessToken: '',
      ),
    );
    registerFallbackValue(
      const RefreshTokenRequest(refreshToken: ''),
    );
  });

  group('AuthRepository', () {
    group('initial state', () {
      test('is not authenticated by default', () {
        expect(sut.isAuthenticated, isFalse);
        expect(sut.accessToken, isEmpty);
        expect(sut.userRole, isEmpty);
      });
    });

    group('login', () {
      test('stores tokens and returns authenticated state', () async {
        final accessJwt = _buildJwt('host');
        when(
          () =>
              mockAuthService.loginApiV1AuthLoginPost(body: any(named: 'body')),
        ).thenAnswer(
          (_) async => TokenResponse(
            accessToken: accessJwt,
            refreshToken: 'refresh_001',
          ),
        );
        when(
          () => mockTokenStorage.writeTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userRole: any(named: 'userRole'),
          ),
        ).thenAnswer((_) async {});

        final state = await sut.login(
          provider: OAuthLoginRequestProvider.google,
          oauthAccessToken: 'google_token',
        );

        expect(state, isA<AuthStateAuthenticated>());
        final auth = state as AuthStateAuthenticated;
        expect(auth.accessToken, accessJwt);
        expect(auth.refreshToken, 'refresh_001');
        expect(auth.userRole, 'host');
        expect(sut.isAuthenticated, isTrue);
        expect(sut.userRole, 'host');
      });

      test('persists tokens to secure storage after login', () async {
        final accessJwt = _buildJwt('concierge');
        when(
          () =>
              mockAuthService.loginApiV1AuthLoginPost(body: any(named: 'body')),
        ).thenAnswer(
          (_) async => TokenResponse(
            accessToken: accessJwt,
            refreshToken: 'refresh_002',
          ),
        );
        when(
          () => mockTokenStorage.writeTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userRole: any(named: 'userRole'),
          ),
        ).thenAnswer((_) async {});

        await sut.login(
          provider: OAuthLoginRequestProvider.google,
          oauthAccessToken: 'google_token',
        );

        verify(
          () => mockTokenStorage.writeTokens(
            accessToken: accessJwt,
            refreshToken: 'refresh_002',
            userRole: 'concierge',
          ),
        ).called(1);
      });
    });

    group('refresh', () {
      test('returns unauthenticated when refresh token is empty', () async {
        final state = await sut.refresh();
        expect(state, isA<AuthStateUnauthenticated>());
      });

      test('returns authenticated state after successful refresh', () async {
        // Seed the in-memory refresh token by going through login first
        final firstJwt = _buildJwt('host');
        when(
          () =>
              mockAuthService.loginApiV1AuthLoginPost(body: any(named: 'body')),
        ).thenAnswer(
          (_) async => TokenResponse(
            accessToken: firstJwt,
            refreshToken: 'refresh_old',
          ),
        );
        when(
          () => mockTokenStorage.writeTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userRole: any(named: 'userRole'),
          ),
        ).thenAnswer((_) async {});
        await sut.login(
          provider: OAuthLoginRequestProvider.google,
          oauthAccessToken: 'google_token',
        );

        final newJwt = _buildJwt('host');
        when(
          () => mockAuthService.refreshTokenApiV1AuthRefreshPost(
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => TokenResponse(
            accessToken: newJwt,
            refreshToken: 'refresh_new',
          ),
        );

        final state = await sut.refresh();

        expect(state, isA<AuthStateAuthenticated>());
        final auth = state as AuthStateAuthenticated;
        expect(auth.accessToken, newJwt);
        expect(auth.refreshToken, 'refresh_new');
      });

      test(
        'calls logout on refresh error and returns unauthenticated',
        () async {
          // Seed refresh token
          final firstJwt = _buildJwt('host');
          when(
            () => mockAuthService.loginApiV1AuthLoginPost(
              body: any(named: 'body'),
            ),
          ).thenAnswer(
            (_) async => TokenResponse(
              accessToken: firstJwt,
              refreshToken: 'refresh_old',
            ),
          );
          when(
            () => mockTokenStorage.writeTokens(
              accessToken: any(named: 'accessToken'),
              refreshToken: any(named: 'refreshToken'),
              userRole: any(named: 'userRole'),
            ),
          ).thenAnswer((_) async {});
          await sut.login(
            provider: OAuthLoginRequestProvider.google,
            oauthAccessToken: 'google_token',
          );

          when(
            () => mockAuthService.refreshTokenApiV1AuthRefreshPost(
              body: any(named: 'body'),
            ),
          ).thenAnswer((_) async => throw Exception('network error'));
          when(
            () => mockAuthService.logoutApiV1AuthLogoutPost(),
          ).thenAnswer((_) async {});
          when(() => mockTokenStorage.deleteAll()).thenAnswer((_) async {});

          final state = await sut.refresh();

          expect(state, isA<AuthStateUnauthenticated>());
          expect(sut.isAuthenticated, isFalse);
        },
      );
    });

    group('logout', () {
      test('clears in-memory state and deletes storage tokens', () async {
        // First login to set tokens
        final accessJwt = _buildJwt('host');
        when(
          () =>
              mockAuthService.loginApiV1AuthLoginPost(body: any(named: 'body')),
        ).thenAnswer(
          (_) async => TokenResponse(
            accessToken: accessJwt,
            refreshToken: 'refresh_001',
          ),
        );
        when(
          () => mockTokenStorage.writeTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userRole: any(named: 'userRole'),
          ),
        ).thenAnswer((_) async {});
        await sut.login(
          provider: OAuthLoginRequestProvider.google,
          oauthAccessToken: 'google_token',
        );

        when(
          () => mockAuthService.logoutApiV1AuthLogoutPost(),
        ).thenAnswer((_) async {});
        when(() => mockTokenStorage.deleteAll()).thenAnswer((_) async {});

        final state = await sut.logout();

        expect(state, isA<AuthStateUnauthenticated>());
        expect(sut.isAuthenticated, isFalse);
        expect(sut.accessToken, isEmpty);
        expect(sut.userRole, isEmpty);
        verify(() => mockTokenStorage.deleteAll()).called(1);
      });

      test('still clears tokens even if server logout call throws', () async {
        // First login to set tokens
        final accessJwt = _buildJwt('host');
        when(
          () =>
              mockAuthService.loginApiV1AuthLoginPost(body: any(named: 'body')),
        ).thenAnswer(
          (_) async => TokenResponse(
            accessToken: accessJwt,
            refreshToken: 'refresh_001',
          ),
        );
        when(
          () => mockTokenStorage.writeTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userRole: any(named: 'userRole'),
          ),
        ).thenAnswer((_) async {});
        await sut.login(
          provider: OAuthLoginRequestProvider.google,
          oauthAccessToken: 'google_token',
        );

        when(
          () => mockAuthService.logoutApiV1AuthLogoutPost(),
        ).thenAnswer((_) async => throw Exception('server error'));
        when(() => mockTokenStorage.deleteAll()).thenAnswer((_) async {});

        final state = await sut.logout();

        expect(state, isA<AuthStateUnauthenticated>());
        expect(sut.isAuthenticated, isFalse);
        verify(() => mockTokenStorage.deleteAll()).called(1);
      });

      test('skips server logout call when not authenticated', () async {
        when(() => mockTokenStorage.deleteAll()).thenAnswer((_) async {});

        final state = await sut.logout();

        expect(state, isA<AuthStateUnauthenticated>());
        verifyNever(() => mockAuthService.logoutApiV1AuthLogoutPost());
      });
    });

    group('restoreSession', () {
      test(
        'returns unauthenticated when no refresh token in storage',
        () async {
          when(
            () => mockTokenStorage.readRefreshToken(),
          ).thenAnswer((_) async => null);

          final state = await sut.restoreSession();

          expect(state, isA<AuthStateUnauthenticated>());
        },
      );

      test(
        'returns unauthenticated when stored refresh token is empty',
        () async {
          when(
            () => mockTokenStorage.readRefreshToken(),
          ).thenAnswer((_) async => '');

          final state = await sut.restoreSession();

          expect(state, isA<AuthStateUnauthenticated>());
        },
      );

      test(
        'calls refresh and returns authenticated when token exists',
        () async {
          when(
            () => mockTokenStorage.readRefreshToken(),
          ).thenAnswer((_) async => 'refresh_stored');

          final newJwt = _buildJwt('host');
          when(
            () => mockAuthService.refreshTokenApiV1AuthRefreshPost(
              body: any(named: 'body'),
            ),
          ).thenAnswer(
            (_) async => TokenResponse(
              accessToken: newJwt,
              refreshToken: 'refresh_new',
            ),
          );
          when(
            () => mockTokenStorage.writeTokens(
              accessToken: any(named: 'accessToken'),
              refreshToken: any(named: 'refreshToken'),
              userRole: any(named: 'userRole'),
            ),
          ).thenAnswer((_) async {});

          final state = await sut.restoreSession();

          expect(state, isA<AuthStateAuthenticated>());
        },
      );
    });

    group('JWT role extraction', () {
      test('extracts host role from valid JWT', () async {
        final accessJwt = _buildJwt('host');
        when(
          () =>
              mockAuthService.loginApiV1AuthLoginPost(body: any(named: 'body')),
        ).thenAnswer(
          (_) async => TokenResponse(
            accessToken: accessJwt,
            refreshToken: 'refresh_001',
          ),
        );
        when(
          () => mockTokenStorage.writeTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userRole: any(named: 'userRole'),
          ),
        ).thenAnswer((_) async {});

        await sut.login(
          provider: OAuthLoginRequestProvider.google,
          oauthAccessToken: 'google_token',
        );

        expect(sut.userRole, 'host');
      });

      test('extracts concierge role from valid JWT', () async {
        final accessJwt = _buildJwt('concierge');
        when(
          () =>
              mockAuthService.loginApiV1AuthLoginPost(body: any(named: 'body')),
        ).thenAnswer(
          (_) async => TokenResponse(
            accessToken: accessJwt,
            refreshToken: 'refresh_001',
          ),
        );
        when(
          () => mockTokenStorage.writeTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userRole: any(named: 'userRole'),
          ),
        ).thenAnswer((_) async {});

        await sut.login(
          provider: OAuthLoginRequestProvider.google,
          oauthAccessToken: 'google_token',
        );

        expect(sut.userRole, 'concierge');
      });

      test('returns empty role when JWT has wrong segment count', () async {
        const malformedJwt = 'not.a.valid.jwt.token.here';
        when(
          () =>
              mockAuthService.loginApiV1AuthLoginPost(body: any(named: 'body')),
        ).thenAnswer(
          (_) async => const TokenResponse(
            accessToken: malformedJwt,
            refreshToken: 'refresh_001',
          ),
        );
        when(
          () => mockTokenStorage.writeTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userRole: any(named: 'userRole'),
          ),
        ).thenAnswer((_) async {});

        await sut.login(
          provider: OAuthLoginRequestProvider.google,
          oauthAccessToken: 'google_token',
        );

        expect(sut.userRole, isEmpty);
      });

      test('returns empty role when payload has no role field', () async {
        final header = base64Url.encode(
          utf8.encode('{"alg":"HS256","typ":"JWT"}'),
        );
        final payload = base64Url.encode(
          utf8.encode('{"sub":"user-id","exp":9999999999}'),
        );
        final noRoleJwt = '$header.$payload.signature';

        when(
          () =>
              mockAuthService.loginApiV1AuthLoginPost(body: any(named: 'body')),
        ).thenAnswer(
          (_) async => TokenResponse(
            accessToken: noRoleJwt,
            refreshToken: 'refresh_001',
          ),
        );
        when(
          () => mockTokenStorage.writeTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userRole: any(named: 'userRole'),
          ),
        ).thenAnswer((_) async {});

        await sut.login(
          provider: OAuthLoginRequestProvider.google,
          oauthAccessToken: 'google_token',
        );

        expect(sut.userRole, isEmpty);
      });
    });
  });
}
