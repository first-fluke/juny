// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preference_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferenceResponse _$NotificationPreferenceResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferenceResponse(
  userId: json['user_id'] as String,
  wellnessAlerts: json['wellness_alerts'] as bool,
  medicationReminders: json['medication_reminders'] as bool,
  systemUpdates: json['system_updates'] as bool,
);

Map<String, dynamic> _$NotificationPreferenceResponseToJson(
  _NotificationPreferenceResponse instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'wellness_alerts': instance.wellnessAlerts,
  'medication_reminders': instance.medicationReminders,
  'system_updates': instance.systemUpdates,
};
