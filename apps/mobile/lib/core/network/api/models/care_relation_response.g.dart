// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_relation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CareRelationResponse _$CareRelationResponseFromJson(
  Map<String, dynamic> json,
) => _CareRelationResponse(
  id: json['id'] as String,
  hostId: json['host_id'] as String,
  caregiverId: json['caregiver_id'] as String,
  role: json['role'] as String,
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CareRelationResponseToJson(
  _CareRelationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'host_id': instance.hostId,
  'caregiver_id': instance.caregiverId,
  'role': instance.role,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
