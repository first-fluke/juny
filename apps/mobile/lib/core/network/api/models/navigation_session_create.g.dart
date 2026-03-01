// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_session_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NavigationSessionCreate _$NavigationSessionCreateFromJson(
  Map<String, dynamic> json,
) => _NavigationSessionCreate(
  hostId: json['host_id'] as String,
  destinationQuery: json['destination_query'] as String,
  originLat: json['origin_lat'] as num,
  originLng: json['origin_lng'] as num,
);

Map<String, dynamic> _$NavigationSessionCreateToJson(
  _NavigationSessionCreate instance,
) => <String, dynamic>{
  'host_id': instance.hostId,
  'destination_query': instance.destinationQuery,
  'origin_lat': instance.originLat,
  'origin_lng': instance.originLng,
};
