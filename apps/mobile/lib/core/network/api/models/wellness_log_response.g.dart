// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_log_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WellnessLogResponse _$WellnessLogResponseFromJson(Map<String, dynamic> json) =>
    _WellnessLogResponse(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      status: json['status'] as String,
      summary: json['summary'] as String,
      details: json['details'],
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$WellnessLogResponseToJson(
  _WellnessLogResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'host_id': instance.hostId,
  'status': instance.status,
  'summary': instance.summary,
  'details': instance.details,
  'created_at': instance.createdAt.toIso8601String(),
};
