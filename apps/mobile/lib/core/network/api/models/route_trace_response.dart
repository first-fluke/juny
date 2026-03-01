// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'location_waypoint_response.dart';

part 'route_trace_response.freezed.dart';
part 'route_trace_response.g.dart';

/// Response model for a session's route trace (waypoint history).
@Freezed()
abstract class RouteTraceResponse with _$RouteTraceResponse {
  const factory RouteTraceResponse({
    @JsonKey(name: 'host_id')
    required String hostId,
    @JsonKey(name: 'session_id')
    required String? sessionId,
    required List<LocationWaypointResponse> waypoints,
    @JsonKey(name: 'total_distance_meters')
    required num totalDistanceMeters,
    @JsonKey(name: 'duration_seconds')
    required num durationSeconds,
  }) = _RouteTraceResponse;
  
  factory RouteTraceResponse.fromJson(Map<String, Object?> json) => _$RouteTraceResponseFromJson(json);
}
