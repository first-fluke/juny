// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleanup_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CleanupRequest _$CleanupRequestFromJson(Map<String, dynamic> json) =>
    _CleanupRequest(
      retentionDays: (json['retention_days'] as num?)?.toInt() ?? 90,
      resourceType: json['resource_type'] as String? ?? 'all',
    );

Map<String, dynamic> _$CleanupRequestToJson(_CleanupRequest instance) =>
    <String, dynamic>{
      'retention_days': instance.retentionDays,
      'resource_type': instance.resourceType,
    };
