// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'device_token_create_platform.dart';

part 'device_token_create.freezed.dart';
part 'device_token_create.g.dart';

/// Payload for registering a device token.
@Freezed()
abstract class DeviceTokenCreate with _$DeviceTokenCreate {
  const factory DeviceTokenCreate({
    required String token,
    required DeviceTokenCreatePlatform platform,
  }) = _DeviceTokenCreate;
  
  factory DeviceTokenCreate.fromJson(Map<String, Object?> json) => _$DeviceTokenCreateFromJson(json);
}
