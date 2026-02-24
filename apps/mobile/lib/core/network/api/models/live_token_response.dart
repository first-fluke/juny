// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'live_token_response_role.dart';

part 'live_token_response.freezed.dart';
part 'live_token_response.g.dart';

@Freezed()
abstract class LiveTokenResponse with _$LiveTokenResponse {
  const factory LiveTokenResponse({
    required String token,
    @JsonKey(name: 'room_name')
    required String roomName,
    required String identity,
    required LiveTokenResponseRole role,
  }) = _LiveTokenResponse;
  
  factory LiveTokenResponse.fromJson(Map<String, Object?> json) => _$LiveTokenResponseFromJson(json);
}
