// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'pagination_meta.dart';
import 'wellness_log_response.dart';

part 'paginated_response_wellness_log_response.freezed.dart';
part 'paginated_response_wellness_log_response.g.dart';

@Freezed()
abstract class PaginatedResponseWellnessLogResponse
    with _$PaginatedResponseWellnessLogResponse {
  const factory PaginatedResponseWellnessLogResponse({
    required List<WellnessLogResponse> data,
    required PaginationMeta meta,
  }) = _PaginatedResponseWellnessLogResponse;

  factory PaginatedResponseWellnessLogResponse.fromJson(
    Map<String, Object?> json,
  ) => _$PaginatedResponseWellnessLogResponseFromJson(json);
}
