// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preference_update.freezed.dart';
part 'notification_preference_update.g.dart';

/// Payload for updating notification preferences.
@Freezed()
abstract class NotificationPreferenceUpdate with _$NotificationPreferenceUpdate {
  const factory NotificationPreferenceUpdate({
    @JsonKey(name: 'wellness_alerts')
    bool? wellnessAlerts,
    @JsonKey(name: 'medication_reminders')
    bool? medicationReminders,
    @JsonKey(name: 'system_updates')
    bool? systemUpdates,
  }) = _NotificationPreferenceUpdate;
  
  factory NotificationPreferenceUpdate.fromJson(Map<String, Object?> json) => _$NotificationPreferenceUpdateFromJson(json);
}
