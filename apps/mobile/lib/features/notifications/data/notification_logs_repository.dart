import 'package:mobile/core/network/api/export.dart';

/// {@template notification_logs_repository}
/// Data layer for notification log read and status-update operations.
/// {@endtemplate}
class NotificationLogsRepository {
  /// {@macro notification_logs_repository}
  NotificationLogsRepository({
    required NotificationLogsService notificationLogsService,
  }) : _service = notificationLogsService;

  final NotificationLogsService _service;

  /// Returns a paginated list of notification logs for the current user.
  Future<PaginatedResponseNotificationLogResponse> listLogs({
    int page = 1,
    int limit = 20,
  }) => _service.listNotificationLogsApiV1NotificationLogsGet(
        page: page,
        limit: limit,
      );

  /// Marks a notification log entry as read.
  Future<NotificationLogResponse> markAsRead(String logId) =>
      _service.updateLogStatusApiV1NotificationLogsLogIdStatusPatch(
        logId: logId,
        body: const NotificationLogStatusUpdate(status: 'read'),
      );
}
