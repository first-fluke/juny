// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_waypoint_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocationWaypointResponse _$LocationWaypointResponseFromJson(
  Map<String, dynamic> json,
) => _LocationWaypointResponse(
  id: json['id'] as String,
  hostId: json['host_id'] as String,
  sessionId: json['session_id'] as String?,
  lat: json['lat'] as num,
  lng: json['lng'] as num,
  altitude: json['altitude'] as num?,
  accuracy: json['accuracy'] as num?,
  speed: json['speed'] as num?,
  heading: json['heading'] as num?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$LocationWaypointResponseToJson(
  _LocationWaypointResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'host_id': instance.hostId,
  'session_id': instance.sessionId,
  'lat': instance.lat,
  'lng': instance.lng,
  'altitude': instance.altitude,
  'accuracy': instance.accuracy,
  'speed': instance.speed,
  'heading': instance.heading,
  'created_at': instance.createdAt.toIso8601String(),
};
