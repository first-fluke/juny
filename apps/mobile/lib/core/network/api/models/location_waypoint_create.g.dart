// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_waypoint_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocationWaypointCreate _$LocationWaypointCreateFromJson(
  Map<String, dynamic> json,
) => _LocationWaypointCreate(
  hostId: json['host_id'] as String,
  lat: json['lat'] as num,
  lng: json['lng'] as num,
  sessionId: json['session_id'] as String?,
  altitude: json['altitude'] as num?,
  accuracy: json['accuracy'] as num?,
  speed: json['speed'] as num?,
  heading: json['heading'] as num?,
);

Map<String, dynamic> _$LocationWaypointCreateToJson(
  _LocationWaypointCreate instance,
) => <String, dynamic>{
  'host_id': instance.hostId,
  'lat': instance.lat,
  'lng': instance.lng,
  'session_id': instance.sessionId,
  'altitude': instance.altitude,
  'accuracy': instance.accuracy,
  'speed': instance.speed,
  'heading': instance.heading,
};
