import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// {@template secure_token_storage}
/// Persists authentication tokens securely using platform keychain/keystore.
/// {@endtemplate}
class SecureTokenStorage {
  /// {@macro secure_token_storage}
  SecureTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userRoleKey = 'user_role';

  /// Read the stored access token.
  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  /// Read the stored refresh token.
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  /// Read the stored user role.
  Future<String?> readUserRole() => _storage.read(key: _userRoleKey);

  /// Persist all auth tokens.
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
    required String userRole,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
      _storage.write(key: _userRoleKey, value: userRole),
    ]);
  }

  /// Delete all stored tokens.
  Future<void> deleteAll() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userRoleKey),
    ]);
  }
}
