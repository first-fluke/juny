// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleanup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CleanupResponse _$CleanupResponseFromJson(Map<String, dynamic> json) =>
    _CleanupResponse(
      deletedWellnessLogs: (json['deleted_wellness_logs'] as num).toInt(),
      deactivatedTokens: (json['deactivated_tokens'] as num).toInt(),
      deletedWaypoints: (json['deleted_waypoints'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CleanupResponseToJson(_CleanupResponse instance) =>
    <String, dynamic>{
      'deleted_wellness_logs': instance.deletedWellnessLogs,
      'deactivated_tokens': instance.deactivatedTokens,
      'deleted_waypoints': instance.deletedWaypoints,
    };
