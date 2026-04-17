// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_waypoint_create.freezed.dart';
part 'location_waypoint_create.g.dart';

/// Request body for recording a single GPS waypoint.
@Freezed()
abstract class LocationWaypointCreate with _$LocationWaypointCreate {
  const factory LocationWaypointCreate({
    @JsonKey(name: 'host_id') required String hostId,
    required num lat,
    required num lng,
    @JsonKey(name: 'session_id') String? sessionId,
    num? altitude,
    num? accuracy,
    num? speed,
    num? heading,
  }) = _LocationWaypointCreate;

  factory LocationWaypointCreate.fromJson(Map<String, Object?> json) =>
      _$LocationWaypointCreateFromJson(json);
}
