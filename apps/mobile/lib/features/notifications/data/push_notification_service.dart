import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

/// {@template push_notification_service}
/// Wraps [FirebaseMessaging] to provide FCM token management,
/// permission requests, and foreground message handling.
/// {@endtemplate}
class PushNotificationService {
  /// {@macro push_notification_service}
  PushNotificationService({FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  /// Request notification permission from the OS.
  ///
  /// On Android 13+ this shows a runtime permission dialog.
  /// On iOS this triggers the native permission prompt.
  /// Returns the resulting [AuthorizationStatus].
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus;
  }

  /// Retrieve the current FCM registration token.
  ///
  /// Returns `null` when the device has not granted permission or
  /// FCM is not available (e.g. emulator without Play Services).
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } on Exception {
      return null;
    }
  }

  /// Subscribe to foreground messages.
  ///
  /// The returned [Stream] emits a [RemoteMessage] each time a push
  /// notification arrives while the app is in the foreground.
  Stream<RemoteMessage> get onForegroundMessage =>
      FirebaseMessaging.onMessage;

  /// Subscribe to token refresh events.
  ///
  /// Callers should re-register the new token with the backend
  /// whenever a refresh event is emitted.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// Platform identifier used when registering a token with the API.
  ///
  /// Returns `'ios'` on iOS, `'android'` on Android, and `'web'` otherwise.
  static String get currentPlatform {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'web';
  }
}
