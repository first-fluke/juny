// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_response.freezed.dart';
part 'audit_log_response.g.dart';

@Freezed()
abstract class AuditLogResponse with _$AuditLogResponse {
  const factory AuditLogResponse({
    required String id,
    @JsonKey(name: 'actor_id')
    required String? actorId,
    required String action,
    @JsonKey(name: 'resource_type')
    required String resourceType,
    required dynamic detail,
    required String? description,
    required DateTime timestamp,
  }) = _AuditLogResponse;
  
  factory AuditLogResponse.fromJson(Map<String, Object?> json) => _$AuditLogResponseFromJson(json);
}
