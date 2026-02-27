// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_relation_update.freezed.dart';
part 'care_relation_update.g.dart';

/// Request body for updating a care relation.
@Freezed()
abstract class CareRelationUpdate with _$CareRelationUpdate {
  const factory CareRelationUpdate({
    @JsonKey(name: 'is_active')
    bool? isActive,
    String? role,
  }) = _CareRelationUpdate;
  
  factory CareRelationUpdate.fromJson(Map<String, Object?> json) => _$CareRelationUpdateFromJson(json);
}
