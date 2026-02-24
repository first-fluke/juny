// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_log_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WellnessLogCreate _$WellnessLogCreateFromJson(Map<String, dynamic> json) =>
    _WellnessLogCreate(
      hostId: json['host_id'] as String,
      status: WellnessStatus.fromJson(json['status'] as String),
      summary: json['summary'] as String,
      details: json['details'],
    );

Map<String, dynamic> _$WellnessLogCreateToJson(_WellnessLogCreate instance) =>
    <String, dynamic>{
      'host_id': instance.hostId,
      'status': _$WellnessStatusEnumMap[instance.status]!,
      'summary': instance.summary,
      'details': instance.details,
    };

const _$WellnessStatusEnumMap = {
  WellnessStatus.normal: 'normal',
  WellnessStatus.warning: 'warning',
  WellnessStatus.emergency: 'emergency',
  WellnessStatus.$unknown: r'$unknown',
};
