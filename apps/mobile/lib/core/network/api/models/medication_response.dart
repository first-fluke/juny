// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_response.freezed.dart';
part 'medication_response.g.dart';

/// Response model for a medication entry.
@Freezed()
abstract class MedicationResponse with _$MedicationResponse {
  const factory MedicationResponse({
    required String id,
    @JsonKey(name: 'host_id') required String hostId,
    @JsonKey(name: 'pill_name') required String pillName,
    @JsonKey(name: 'schedule_time') required DateTime scheduleTime,
    @JsonKey(name: 'is_taken') required bool isTaken,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'taken_at') DateTime? takenAt,
  }) = _MedicationResponse;

  factory MedicationResponse.fromJson(Map<String, Object?> json) =>
      _$MedicationResponseFromJson(json);
}
