import 'package:mobile/core/network/api/export.dart';

/// {@template notifications_repository}
/// Data layer for device token and notification preference operations.
/// {@endtemplate}
class NotificationsRepository {
  /// {@macro notifications_repository}
  NotificationsRepository({
    required NotificationsService notificationsService,
    required NotificationLogsService notificationLogsService,
  }) : _notificationsService = notificationsService,
       _notificationLogsService = notificationLogsService;

  final NotificationsService _notificationsService;
  final NotificationLogsService _notificationLogsService;

  Future<List<DeviceTokenResponse>> listDeviceTokens() =>
      _notificationsService.listDeviceTokensApiV1NotificationsDeviceTokensGet();

  Future<DeviceTokenResponse> registerDeviceToken({
    required String token,
    required DeviceTokenCreatePlatform platform,
  }) => _notificationsService
      .registerDeviceTokenApiV1NotificationsDeviceTokensPost(
        body: DeviceTokenCreate(token: token, platform: platform),
      );

  Future<void> unregisterDeviceToken(String tokenId) => _notificationsService
      .unregisterDeviceTokenApiV1NotificationsDeviceTokensTokenIdDelete(
        tokenId: tokenId,
      );

  Future<PaginatedResponseNotificationLogResponse> listLogs({
    int page = 1,
    int limit = 20,
  }) => _notificationLogsService.listNotificationLogsApiV1NotificationLogsGet(
    page: page,
    limit: limit,
  );

  Future<NotificationPreferenceResponse> getPreferences() =>
      _notificationLogsService
          .getPreferencesApiV1NotificationLogsPreferencesGet();

  Future<NotificationPreferenceResponse> updatePreferences({
    bool? wellnessAlerts,
    bool? medicationReminders,
    bool? systemUpdates,
  }) => _notificationLogsService
      .updatePreferencesApiV1NotificationLogsPreferencesPut(
        body: NotificationPreferenceUpdate(
          wellnessAlerts: wellnessAlerts,
          medicationReminders: medicationReminders,
          systemUpdates: systemUpdates,
        ),
      );

  Future<NotificationLogResponse> updateLogStatus({
    required String logId,
    required String status,
  }) => _notificationLogsService
      .updateLogStatusApiV1NotificationLogsLogIdStatusPatch(
        logId: logId,
        body: NotificationLogStatusUpdate(status: status),
      );
}
