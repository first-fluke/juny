// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/notification_log_response.dart';
import '../models/notification_log_status_update.dart';
import '../models/notification_preference_response.dart';
import '../models/notification_preference_update.dart';
import '../models/paginated_response_notification_log_response.dart';

part 'notification_logs_service.g.dart';

@RestApi()
abstract class NotificationLogsService {
  factory NotificationLogsService(Dio dio, {String? baseUrl}) =
      _NotificationLogsService;

  /// List Notification Logs.
  ///
  /// List notification logs for the current user (own notifications only).
  @GET('/api/v1/notification-logs')
  Future<PaginatedResponseNotificationLogResponse>
  listNotificationLogsApiV1NotificationLogsGet({
    @Query('page') int? page = 1,
    @Query('limit') int? limit = 20,
  });

  /// Get Preferences.
  ///
  /// Get notification preferences for the current user.
  @GET('/api/v1/notification-logs/preferences')
  Future<NotificationPreferenceResponse>
  getPreferencesApiV1NotificationLogsPreferencesGet();

  /// Update Preferences.
  ///
  /// Update notification preferences for the current user.
  @PUT('/api/v1/notification-logs/preferences')
  Future<NotificationPreferenceResponse>
  updatePreferencesApiV1NotificationLogsPreferencesPut({
    @Body() required NotificationPreferenceUpdate body,
  });

  /// Update Log Status.
  ///
  /// Update notification log delivery status (internal/worker callback).
  @PATCH('/api/v1/notification-logs/{log_id}/status')
  Future<NotificationLogResponse>
  updateLogStatusApiV1NotificationLogsLogIdStatusPatch({
    @Path('log_id') required String logId,
    @Body() required NotificationLogStatusUpdate body,
  });
}
