// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'medication_response.dart';
import 'pagination_meta.dart';

part 'paginated_response_medication_response.freezed.dart';
part 'paginated_response_medication_response.g.dart';

@Freezed()
abstract class PaginatedResponseMedicationResponse
    with _$PaginatedResponseMedicationResponse {
  const factory PaginatedResponseMedicationResponse({
    required List<MedicationResponse> data,
    required PaginationMeta meta,
  }) = _PaginatedResponseMedicationResponse;

  factory PaginatedResponseMedicationResponse.fromJson(
    Map<String, Object?> json,
  ) => _$PaginatedResponseMedicationResponseFromJson(json);
}
