// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cleanup_response.freezed.dart';
part 'cleanup_response.g.dart';

@Freezed()
abstract class CleanupResponse with _$CleanupResponse {
  const factory CleanupResponse({
    @JsonKey(name: 'deleted_wellness_logs')
    required int deletedWellnessLogs,
    @JsonKey(name: 'deactivated_tokens')
    required int deactivatedTokens,
  }) = _CleanupResponse;
  
  factory CleanupResponse.fromJson(Map<String, Object?> json) => _$CleanupResponseFromJson(json);
}
