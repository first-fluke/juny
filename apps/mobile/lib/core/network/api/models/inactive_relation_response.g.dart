// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inactive_relation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InactiveRelationResponse _$InactiveRelationResponseFromJson(
  Map<String, dynamic> json,
) => _InactiveRelationResponse(
  relationId: json['relation_id'] as String,
  hostId: json['host_id'] as String,
  caregiverId: json['caregiver_id'] as String,
  role: json['role'] as String,
  lastWellnessAt: json['last_wellness_at'] == null
      ? null
      : DateTime.parse(json['last_wellness_at'] as String),
  inactiveDays: (json['inactive_days'] as num).toInt(),
);

Map<String, dynamic> _$InactiveRelationResponseToJson(
  _InactiveRelationResponse instance,
) => <String, dynamic>{
  'relation_id': instance.relationId,
  'host_id': instance.hostId,
  'caregiver_id': instance.caregiverId,
  'role': instance.role,
  'last_wellness_at': instance.lastWellnessAt?.toIso8601String(),
  'inactive_days': instance.inactiveDays,
};
