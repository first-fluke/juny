// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'care_relation_response.dart';
import 'pagination_meta.dart';

part 'paginated_response_care_relation_response.freezed.dart';
part 'paginated_response_care_relation_response.g.dart';

@Freezed()
abstract class PaginatedResponseCareRelationResponse with _$PaginatedResponseCareRelationResponse {
  const factory PaginatedResponseCareRelationResponse({
    required List<CareRelationResponse> data,
    required PaginationMeta meta,
  }) = _PaginatedResponseCareRelationResponse;
  
  factory PaginatedResponseCareRelationResponse.fromJson(Map<String, Object?> json) => _$PaginatedResponseCareRelationResponseFromJson(json);
}
