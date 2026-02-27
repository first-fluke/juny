// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_update.freezed.dart';
part 'medication_update.g.dart';

/// Request body for updating a medication.
@Freezed()
abstract class MedicationUpdate with _$MedicationUpdate {
  const factory MedicationUpdate({
    @JsonKey(name: 'pill_name')
    String? pillName,
    @JsonKey(name: 'schedule_time')
    DateTime? scheduleTime,
    @JsonKey(name: 'is_taken')
    bool? isTaken,
  }) = _MedicationUpdate;
  
  factory MedicationUpdate.fromJson(Map<String, Object?> json) => _$MedicationUpdateFromJson(json);
}
