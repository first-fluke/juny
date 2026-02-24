// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicationResponse _$MedicationResponseFromJson(Map<String, dynamic> json) =>
    _MedicationResponse(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      pillName: json['pill_name'] as String,
      scheduleTime: DateTime.parse(json['schedule_time'] as String),
      isTaken: json['is_taken'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      takenAt: json['taken_at'] == null
          ? null
          : DateTime.parse(json['taken_at'] as String),
    );

Map<String, dynamic> _$MedicationResponseToJson(_MedicationResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'host_id': instance.hostId,
      'pill_name': instance.pillName,
      'schedule_time': instance.scheduleTime.toIso8601String(),
      'is_taken': instance.isTaken,
      'created_at': instance.createdAt.toIso8601String(),
      'taken_at': instance.takenAt?.toIso8601String(),
    };
