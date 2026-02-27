// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cleanup_request.freezed.dart';
part 'cleanup_request.g.dart';

@Freezed()
abstract class CleanupRequest with _$CleanupRequest {
  const factory CleanupRequest({
    @JsonKey(name: 'retention_days')
    @Default(90)
    int retentionDays,
    @JsonKey(name: 'resource_type')
    @Default('all')
    String resourceType,
  }) = _CleanupRequest;
  
  factory CleanupRequest.fromJson(Map<String, Object?> json) => _$CleanupRequestFromJson(json);
}
