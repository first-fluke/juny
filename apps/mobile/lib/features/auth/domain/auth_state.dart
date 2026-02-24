import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// {@template auth_state}
/// Represents the authentication state of the current user.
/// {@endtemplate}
@Freezed()
sealed class AuthState with _$AuthState {
  /// User is not authenticated.
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;

  /// Authentication is being checked.
  const factory AuthState.loading() = AuthStateLoading;

  /// User is authenticated.
  const factory AuthState.authenticated({
    required String accessToken,
    required String refreshToken,
    required String userRole,
  }) = AuthStateAuthenticated;
}
