// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_token_response.freezed.dart';
part 'device_token_response.g.dart';

/// Public device token representation.
@Freezed()
abstract class DeviceTokenResponse with _$DeviceTokenResponse {
  const factory DeviceTokenResponse({
    required String id,
    @JsonKey(name: 'user_id')
    required String userId,
    required String token,
    required String platform,
    @JsonKey(name: 'is_active')
    required bool isActive,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
  }) = _DeviceTokenResponse;
  
  factory DeviceTokenResponse.fromJson(Map<String, Object?> json) => _$DeviceTokenResponseFromJson(json);
}
