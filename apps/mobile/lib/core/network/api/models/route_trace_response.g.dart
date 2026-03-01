// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_trace_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouteTraceResponse _$RouteTraceResponseFromJson(Map<String, dynamic> json) =>
    _RouteTraceResponse(
      hostId: json['host_id'] as String,
      sessionId: json['session_id'] as String?,
      waypoints: (json['waypoints'] as List<dynamic>)
          .map(
            (e) => LocationWaypointResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      totalDistanceMeters: json['total_distance_meters'] as num,
      durationSeconds: json['duration_seconds'] as num,
    );

Map<String, dynamic> _$RouteTraceResponseToJson(_RouteTraceResponse instance) =>
    <String, dynamic>{
      'host_id': instance.hostId,
      'session_id': instance.sessionId,
      'waypoints': instance.waypoints,
      'total_distance_meters': instance.totalDistanceMeters,
      'duration_seconds': instance.durationSeconds,
    };
