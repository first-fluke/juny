// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preference_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferenceUpdate _$NotificationPreferenceUpdateFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferenceUpdate(
  wellnessAlerts: json['wellness_alerts'] as bool?,
  medicationReminders: json['medication_reminders'] as bool?,
  systemUpdates: json['system_updates'] as bool?,
);

Map<String, dynamic> _$NotificationPreferenceUpdateToJson(
  _NotificationPreferenceUpdate instance,
) => <String, dynamic>{
  'wellness_alerts': instance.wellnessAlerts,
  'medication_reminders': instance.medicationReminders,
  'system_updates': instance.systemUpdates,
};
