// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preference_response.freezed.dart';
part 'notification_preference_response.g.dart';

/// Read-only representation of notification preferences.
@Freezed()
abstract class NotificationPreferenceResponse
    with _$NotificationPreferenceResponse {
  const factory NotificationPreferenceResponse({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'wellness_alerts') required bool wellnessAlerts,
    @JsonKey(name: 'medication_reminders') required bool medicationReminders,
    @JsonKey(name: 'system_updates') required bool systemUpdates,
  }) = _NotificationPreferenceResponse;

  factory NotificationPreferenceResponse.fromJson(Map<String, Object?> json) =>
      _$NotificationPreferenceResponseFromJson(json);
}
