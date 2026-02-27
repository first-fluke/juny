// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_relation_response.freezed.dart';
part 'care_relation_response.g.dart';

/// Response model for a care relation.
@Freezed()
abstract class CareRelationResponse with _$CareRelationResponse {
  const factory CareRelationResponse({
    required String id,
    @JsonKey(name: 'host_id')
    required String hostId,
    @JsonKey(name: 'caregiver_id')
    required String caregiverId,
    required String role,
    @JsonKey(name: 'is_active')
    required bool isActive,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
    @JsonKey(name: 'updated_at')
    DateTime? updatedAt,
  }) = _CareRelationResponse;
  
  factory CareRelationResponse.fromJson(Map<String, Object?> json) => _$CareRelationResponseFromJson(json);
}
