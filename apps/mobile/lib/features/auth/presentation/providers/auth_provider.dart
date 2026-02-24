import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Authentication notifier that manages the [AuthState].
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    final apiClient = ref.watch(apiClientWrapperProvider);
    _repository = AuthRepository(
      authService: AuthenticationService(apiClient.dio),
    );
    return const AuthState.unauthenticated();
  }

  /// Login with an OAuth provider.
  Future<void> login({
    required OAuthLoginRequestProvider provider,
    required String oauthAccessToken,
  }) async {
    state = const AuthState.loading();
    try {
      state = await _repository.login(
        provider: provider,
        oauthAccessToken: oauthAccessToken,
      );
    } on Exception {
      state = const AuthState.unauthenticated();
    }
  }

  /// Logout the current user.
  Future<void> logout() async {
    state = await _repository.logout();
  }

  /// Get the current access token.
  String get accessToken => _repository.accessToken;

  /// Get the current user role.
  String get userRole => _repository.userRole;

  /// Whether the user is authenticated.
  bool get isAuthenticated => _repository.isAuthenticated;
}

/// Provider for the [ApiClientWrapper].
@Riverpod(keepAlive: true)
ApiClientWrapper apiClientWrapper(Ref ref) {
  String tokenGetter() {
    final authState = ref.read(authProvider);
    return switch (authState) {
      AuthStateAuthenticated(:final accessToken) => accessToken,
      _ => '',
    };
  }

  return ApiClientWrapper(tokenGetter: tokenGetter);
}
