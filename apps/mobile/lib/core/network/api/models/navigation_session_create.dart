// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_session_create.freezed.dart';
part 'navigation_session_create.g.dart';

/// Request body for starting a navigation session.
@Freezed()
abstract class NavigationSessionCreate with _$NavigationSessionCreate {
  const factory NavigationSessionCreate({
    @JsonKey(name: 'host_id') required String hostId,
    @JsonKey(name: 'destination_query') required String destinationQuery,
    @JsonKey(name: 'origin_lat') required num originLat,
    @JsonKey(name: 'origin_lng') required num originLng,
  }) = _NavigationSessionCreate;

  factory NavigationSessionCreate.fromJson(Map<String, Object?> json) =>
      _$NavigationSessionCreateFromJson(json);
}
