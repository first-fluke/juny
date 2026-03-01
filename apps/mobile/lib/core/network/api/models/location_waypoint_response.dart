// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_waypoint_response.freezed.dart';
part 'location_waypoint_response.g.dart';

/// Response model for a location waypoint.
@Freezed()
abstract class LocationWaypointResponse with _$LocationWaypointResponse {
  const factory LocationWaypointResponse({
    required String id,
    @JsonKey(name: 'host_id')
    required String hostId,
    @JsonKey(name: 'session_id')
    required String? sessionId,
    required num lat,
    required num lng,
    required num? altitude,
    required num? accuracy,
    required num? speed,
    required num? heading,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
  }) = _LocationWaypointResponse;
  
  factory LocationWaypointResponse.fromJson(Map<String, Object?> json) => _$LocationWaypointResponseFromJson(json);
}
