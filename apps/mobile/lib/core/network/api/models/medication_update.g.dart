// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicationUpdate _$MedicationUpdateFromJson(Map<String, dynamic> json) =>
    _MedicationUpdate(
      pillName: json['pill_name'] as String?,
      scheduleTime: json['schedule_time'] == null
          ? null
          : DateTime.parse(json['schedule_time'] as String),
      isTaken: json['is_taken'] as bool?,
    );

Map<String, dynamic> _$MedicationUpdateToJson(_MedicationUpdate instance) =>
    <String, dynamic>{
      'pill_name': instance.pillName,
      'schedule_time': instance.scheduleTime?.toIso8601String(),
      'is_taken': instance.isTaken,
    };
