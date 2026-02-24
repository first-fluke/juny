import 'dart:convert';

import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/domain/auth_state.dart';

/// {@template auth_repository}
/// Manages authentication state and token lifecycle.
/// {@endtemplate}
class AuthRepository {
  /// {@macro auth_repository}
  AuthRepository({required AuthenticationService authService})
    : _authService = authService;

  final AuthenticationService _authService;

  String _accessToken = '';
  String _refreshToken = '';
  String _userRole = '';

  /// Current access token for API requests.
  String get accessToken => _accessToken;

  /// Current user role.
  String get userRole => _userRole;

  /// Whether the user is currently authenticated.
  bool get isAuthenticated => _accessToken.isNotEmpty;

  /// Login via OAuth provider.
  Future<AuthState> login({
    required OAuthLoginRequestProvider provider,
    required String oauthAccessToken,
  }) async {
    final response = await _authService.loginApiV1AuthLoginPost(
      body: OAuthLoginRequest(
        provider: provider,
        accessToken: oauthAccessToken,
      ),
    );

    _accessToken = response.accessToken;
    _refreshToken = response.refreshToken;
    _userRole = _extractRole(response.accessToken);

    return AuthState.authenticated(
      accessToken: _accessToken,
      refreshToken: _refreshToken,
      userRole: _userRole,
    );
  }

  /// Refresh the access token.
  Future<AuthState> refresh() async {
    if (_refreshToken.isEmpty) {
      return const AuthState.unauthenticated();
    }

    try {
      final response = await _authService.refreshTokenApiV1AuthRefreshPost(
        body: RefreshTokenRequest(refreshToken: _refreshToken),
      );

      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;
      _userRole = _extractRole(response.accessToken);

      return AuthState.authenticated(
        accessToken: _accessToken,
        refreshToken: _refreshToken,
        userRole: _userRole,
      );
    } on Exception {
      return logout();
    }
  }

  /// Clear tokens and log out.
  Future<AuthState> logout() async {
    try {
      if (_accessToken.isNotEmpty) {
        await _authService.logoutApiV1AuthLogoutPost();
      }
    } on Exception {
      // Ignore logout errors
    } finally {
      _accessToken = '';
      _refreshToken = '';
      _userRole = '';
    }
    return const AuthState.unauthenticated();
  }

  /// Extract role from JWT payload (base64 decode the payload segment).
  String _extractRole(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return '';

      // Decode the payload
      var payload = parts[1];
      // Add padding if needed
      switch (payload.length % 4) {
        case 2:
          payload += '==';
        case 3:
          payload += '=';
      }

      final decoded = String.fromCharCodes(
        const Base64Decoder().convert(payload),
      );

      // Simple JSON parse for role field
      final roleMatch = RegExp(r'"role"\s*:\s*"([^"]+)"').firstMatch(decoded);
      return roleMatch?.group(1) ?? '';
    } on Exception {
      return '';
    }
  }
}
