// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_create.freezed.dart';
part 'medication_create.g.dart';

/// Request body for creating a medication schedule.
@Freezed()
abstract class MedicationCreate with _$MedicationCreate {
  const factory MedicationCreate({
    @JsonKey(name: 'host_id')
    required String hostId,
    @JsonKey(name: 'pill_name')
    required String pillName,
    @JsonKey(name: 'schedule_time')
    required DateTime scheduleTime,
  }) = _MedicationCreate;
  
  factory MedicationCreate.fromJson(Map<String, Object?> json) => _$MedicationCreateFromJson(json);
}
