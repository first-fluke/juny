import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// {@template local_notification_service}
/// Displays banner notifications while the app is in the foreground.
///
/// FCM only shows the system notification tray when the app is in the
/// background on iOS and when `notification` payload is present on Android.
/// For consistent foreground UX we mirror incoming [RemoteMessage]s via
/// `flutter_local_notifications`.
/// {@endtemplate}
class LocalNotificationService {
  /// {@macro local_notification_service}
  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'juny_default',
        'General',
        description: '앱 공지 및 일반 알림 채널',
        importance: Importance.high,
      );

  bool _initialised = false;

  /// Prepare platform channels. Safe to call multiple times.
  Future<void> initialize() async {
    if (_initialised) return;

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_androidChannel);
    }

    _initialised = true;
  }

  /// Display [message] as a banner while the app is in the foreground.
  ///
  /// Silently skips messages without a `notification` payload so data-only
  /// pushes don't surface an empty banner.
  Future<void> showForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _plugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: notification.android?.smallIcon,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }
}
