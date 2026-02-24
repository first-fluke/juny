// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_relation_create.freezed.dart';
part 'care_relation_create.g.dart';

/// Request body for creating a care relation.
@Freezed()
abstract class CareRelationCreate with _$CareRelationCreate {
  const factory CareRelationCreate({
    @JsonKey(name: 'host_id') required String hostId,
    @JsonKey(name: 'caregiver_id') required String caregiverId,

    /// Caregiver role
    required String role,
  }) = _CareRelationCreate;

  factory CareRelationCreate.fromJson(Map<String, Object?> json) =>
      _$CareRelationCreateFromJson(json);
}
