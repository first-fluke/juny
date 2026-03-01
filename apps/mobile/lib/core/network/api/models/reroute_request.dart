// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reroute_request.freezed.dart';
part 'reroute_request.g.dart';

/// Request body for rerouting from the current location.
@Freezed()
abstract class RerouteRequest with _$RerouteRequest {
  const factory RerouteRequest({
    @JsonKey(name: 'current_lat')
    required num currentLat,
    @JsonKey(name: 'current_lng')
    required num currentLng,
  }) = _RerouteRequest;
  
  factory RerouteRequest.fromJson(Map<String, Object?> json) => _$RerouteRequestFromJson(json);
}
