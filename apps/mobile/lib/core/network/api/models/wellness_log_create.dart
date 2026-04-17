// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'wellness_status.dart';

part 'wellness_log_create.freezed.dart';
part 'wellness_log_create.g.dart';

/// Request body for creating a wellness log.
@Freezed()
abstract class WellnessLogCreate with _$WellnessLogCreate {
  const factory WellnessLogCreate({
    @JsonKey(name: 'host_id') required String hostId,
    required WellnessStatus status,
    required String summary,
    dynamic details,
  }) = _WellnessLogCreate;

  factory WellnessLogCreate.fromJson(Map<String, Object?> json) =>
      _$WellnessLogCreateFromJson(json);
}
