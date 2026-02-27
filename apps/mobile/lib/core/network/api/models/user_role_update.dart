// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_role_update.freezed.dart';
part 'user_role_update.g.dart';

/// Payload for admin role change.
@Freezed()
abstract class UserRoleUpdate with _$UserRoleUpdate {
  const factory UserRoleUpdate({
    required String role,
  }) = _UserRoleUpdate;
  
  factory UserRoleUpdate.fromJson(Map<String, Object?> json) => _$UserRoleUpdateFromJson(json);
}
