// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLogResponse _$AuditLogResponseFromJson(Map<String, dynamic> json) =>
    _AuditLogResponse(
      id: json['id'] as String,
      actorId: json['actor_id'] as String?,
      action: json['action'] as String,
      resourceType: json['resource_type'] as String,
      detail: json['detail'],
      description: json['description'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$AuditLogResponseToJson(_AuditLogResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actor_id': instance.actorId,
      'action': instance.action,
      'resource_type': instance.resourceType,
      'detail': instance.detail,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
    };
