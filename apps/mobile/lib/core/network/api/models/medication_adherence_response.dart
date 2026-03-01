// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_adherence_response.freezed.dart';
part 'medication_adherence_response.g.dart';

/// Medication adherence statistics.
@Freezed()
abstract class MedicationAdherenceResponse with _$MedicationAdherenceResponse {
  const factory MedicationAdherenceResponse({
    @JsonKey(name: 'host_id')
    required String hostId,
    @JsonKey(name: 'date_from')
    required String dateFrom,
    @JsonKey(name: 'date_to')
    required String dateTo,
    required int total,
    required int taken,
    required int missed,
    @JsonKey(name: 'adherence_rate')
    required num adherenceRate,
  }) = _MedicationAdherenceResponse;
  
  factory MedicationAdherenceResponse.fromJson(Map<String, Object?> json) => _$MedicationAdherenceResponseFromJson(json);
}
