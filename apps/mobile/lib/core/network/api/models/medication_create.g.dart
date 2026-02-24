// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicationCreate _$MedicationCreateFromJson(Map<String, dynamic> json) =>
    _MedicationCreate(
      hostId: json['host_id'] as String,
      pillName: json['pill_name'] as String,
      scheduleTime: DateTime.parse(json['schedule_time'] as String),
    );

Map<String, dynamic> _$MedicationCreateToJson(_MedicationCreate instance) =>
    <String, dynamic>{
      'host_id': instance.hostId,
      'pill_name': instance.pillName,
      'schedule_time': instance.scheduleTime.toIso8601String(),
    };
