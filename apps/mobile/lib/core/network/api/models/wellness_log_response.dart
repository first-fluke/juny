// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wellness_log_response.freezed.dart';
part 'wellness_log_response.g.dart';

/// Response model for a wellness log.
@Freezed()
abstract class WellnessLogResponse with _$WellnessLogResponse {
  const factory WellnessLogResponse({
    required String id,
    @JsonKey(name: 'host_id') required String hostId,
    required String status,
    required String summary,
    required dynamic details,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _WellnessLogResponse;

  factory WellnessLogResponse.fromJson(Map<String, Object?> json) =>
      _$WellnessLogResponseFromJson(json);
}
