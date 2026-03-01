// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_log_response.dart';
import 'pagination_meta.dart';

part 'paginated_response_notification_log_response.freezed.dart';
part 'paginated_response_notification_log_response.g.dart';

@Freezed()
abstract class PaginatedResponseNotificationLogResponse with _$PaginatedResponseNotificationLogResponse {
  const factory PaginatedResponseNotificationLogResponse({
    required List<NotificationLogResponse> data,
    required PaginationMeta meta,
  }) = _PaginatedResponseNotificationLogResponse;
  
  factory PaginatedResponseNotificationLogResponse.fromJson(Map<String, Object?> json) => _$PaginatedResponseNotificationLogResponseFromJson(json);
}
