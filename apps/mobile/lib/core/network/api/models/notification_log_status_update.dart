// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_log_status_update.freezed.dart';
part 'notification_log_status_update.g.dart';

/// Payload for updating a notification log's delivery status.
@Freezed()
abstract class NotificationLogStatusUpdate with _$NotificationLogStatusUpdate {
  const factory NotificationLogStatusUpdate({
    required String status,
  }) = _NotificationLogStatusUpdate;
  
  factory NotificationLogStatusUpdate.fromJson(Map<String, Object?> json) => _$NotificationLogStatusUpdateFromJson(json);
}
