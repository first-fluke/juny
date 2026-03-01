// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reroute_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RerouteRequest _$RerouteRequestFromJson(Map<String, dynamic> json) =>
    _RerouteRequest(
      currentLat: json['current_lat'] as num,
      currentLng: json['current_lng'] as num,
    );

Map<String, dynamic> _$RerouteRequestToJson(_RerouteRequest instance) =>
    <String, dynamic>{
      'current_lat': instance.currentLat,
      'current_lng': instance.currentLng,
    };
