// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NavigationSessionResponse _$NavigationSessionResponseFromJson(
  Map<String, dynamic> json,
) => _NavigationSessionResponse(
  id: json['id'] as String,
  hostId: json['host_id'] as String,
  status: json['status'] as String,
  destinationName: json['destination_name'] as String,
  destinationLat: json['destination_lat'] as num,
  destinationLng: json['destination_lng'] as num,
  originLat: json['origin_lat'] as num,
  originLng: json['origin_lng'] as num,
  routeData: json['route_data'],
  currentStepIndex: (json['current_step_index'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
);

Map<String, dynamic> _$NavigationSessionResponseToJson(
  _NavigationSessionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'host_id': instance.hostId,
  'status': instance.status,
  'destination_name': instance.destinationName,
  'destination_lat': instance.destinationLat,
  'destination_lng': instance.destinationLng,
  'origin_lat': instance.originLat,
  'origin_lng': instance.originLng,
  'route_data': instance.routeData,
  'current_step_index': instance.currentStepIndex,
  'created_at': instance.createdAt.toIso8601String(),
  'completed_at': instance.completedAt?.toIso8601String(),
};
