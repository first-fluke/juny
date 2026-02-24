// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_relation_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CareRelationCreate _$CareRelationCreateFromJson(Map<String, dynamic> json) =>
    _CareRelationCreate(
      hostId: json['host_id'] as String,
      caregiverId: json['caregiver_id'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$CareRelationCreateToJson(_CareRelationCreate instance) =>
    <String, dynamic>{
      'host_id': instance.hostId,
      'caregiver_id': instance.caregiverId,
      'role': instance.role,
    };
