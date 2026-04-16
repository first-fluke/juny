import 'dart:async';

import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/domain/auth_state.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/notifications/data/push_notification_service.dart';
import 'package:mobile/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_notification_provider.g.dart';

/// Provides the singleton [PushNotificationService] instance.
@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(Ref ref) {
  return PushNotificationService();
}

/// Manages the full FCM lifecycle: permission, token registration, and
/// token refresh in response to authentication state changes.
///
/// Keep-alive so the subscription persists for the entire app lifetime.
@Riverpod(keepAlive: true)
class PushNotification extends _$PushNotification {
  StreamSubscription<String>? _tokenRefreshSub;

  @override
  Future<void> build() async {
    ref
      // Listen for auth state changes and register/unregister the FCM token.
      ..listen<AuthState>(authProvider, (previous, next) {
        unawaited(_onAuthStateChanged(previous, next));
      })
      // Cancel token refresh subscription when the provider is disposed.
      ..onDispose(() {
        unawaited(_tokenRefreshSub?.cancel());
      });
  }

  /// Initialise FCM: request permission and register the current token.
  ///
  /// Call this once after the user has been authenticated (or on app start).
  Future<void> initialize() async {
    final service = ref.read(pushNotificationServiceProvider);

    await service.requestPermission();

    final token = await service.getToken();
    if (token != null) {
      await _registerToken(token);
    }

    // Re-register whenever FCM rotates the token.
    _tokenRefreshSub = service.onTokenRefresh.listen((newToken) {
      unawaited(_registerToken(newToken));
    });
  }

  /// Unregister all active device tokens from the backend.
  Future<void> unregister() async {
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;

    try {
      final repository = ref.read(notificationsRepositoryProvider);
      final tokens = await repository.listDeviceTokens();
      for (final t in tokens) {
        await repository.unregisterDeviceToken(t.id);
      }
    } on Exception {
      // Swallow errors — the server will expire stale tokens anyway.
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<void> _onAuthStateChanged(
    AuthState? previous,
    AuthState next,
  ) async {
    switch (next) {
      case AuthStateAuthenticated():
        // Only (re-)initialise when transitioning into authenticated state.
        if (previous is! AuthStateAuthenticated) {
          await initialize();
        }
      case AuthStateUnauthenticated():
        // Only unregister when transitioning out of authenticated state.
        if (previous is AuthStateAuthenticated) {
          await unregister();
        }
      case AuthStateLoading():
        break;
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      final repository = ref.read(notificationsRepositoryProvider);
      await repository.registerDeviceToken(
        token: token,
        platform: DeviceTokenCreatePlatform.fromJson(
          PushNotificationService.currentPlatform,
        ),
      );
    } on Exception {
      // Registration failures are non-fatal; the user can still use the app.
    }
  }
}
