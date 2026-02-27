// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'inactive_relation_response.freezed.dart';
part 'inactive_relation_response.g.dart';

@Freezed()
abstract class InactiveRelationResponse with _$InactiveRelationResponse {
  const factory InactiveRelationResponse({
    @JsonKey(name: 'relation_id')
    required String relationId,
    @JsonKey(name: 'host_id')
    required String hostId,
    @JsonKey(name: 'caregiver_id')
    required String caregiverId,
    required String role,
    @JsonKey(name: 'last_wellness_at')
    required DateTime? lastWellnessAt,
    @JsonKey(name: 'inactive_days')
    required int inactiveDays,
  }) = _InactiveRelationResponse;
  
  factory InactiveRelationResponse.fromJson(Map<String, Object?> json) => _$InactiveRelationResponseFromJson(json);
}
