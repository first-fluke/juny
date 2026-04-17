// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_session_response.freezed.dart';
part 'navigation_session_response.g.dart';

/// Response model for a navigation session.
@Freezed()
abstract class NavigationSessionResponse with _$NavigationSessionResponse {
  const factory NavigationSessionResponse({
    required String id,
    @JsonKey(name: 'host_id') required String hostId,
    required String status,
    @JsonKey(name: 'destination_name') required String destinationName,
    @JsonKey(name: 'destination_lat') required num destinationLat,
    @JsonKey(name: 'destination_lng') required num destinationLng,
    @JsonKey(name: 'origin_lat') required num originLat,
    @JsonKey(name: 'origin_lng') required num originLng,
    @JsonKey(name: 'route_data') required dynamic routeData,
    @JsonKey(name: 'current_step_index') required int currentStepIndex,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'completed_at') required DateTime? completedAt,
  }) = _NavigationSessionResponse;

  factory NavigationSessionResponse.fromJson(Map<String, Object?> json) =>
      _$NavigationSessionResponseFromJson(json);
}
