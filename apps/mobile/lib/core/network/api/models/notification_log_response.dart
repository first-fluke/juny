// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_log_response.freezed.dart';
part 'notification_log_response.g.dart';

/// Read-only representation of a notification log entry.
@Freezed()
abstract class NotificationLogResponse with _$NotificationLogResponse {
  const factory NotificationLogResponse({
    required String id,
    @JsonKey(name: 'recipient_id') required String recipientId,
    required String title,
    required String body,
    required String status,
    required String channel,
    required dynamic metadata,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _NotificationLogResponse;

  factory NotificationLogResponse.fromJson(Map<String, Object?> json) =>
      _$NotificationLogResponseFromJson(json);
}
