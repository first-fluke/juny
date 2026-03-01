// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'audit_log_response.dart';
import 'pagination_meta.dart';

part 'paginated_response_audit_log_response.freezed.dart';
part 'paginated_response_audit_log_response.g.dart';

@Freezed()
abstract class PaginatedResponseAuditLogResponse with _$PaginatedResponseAuditLogResponse {
  const factory PaginatedResponseAuditLogResponse({
    required List<AuditLogResponse> data,
    required PaginationMeta meta,
  }) = _PaginatedResponseAuditLogResponse;
  
  factory PaginatedResponseAuditLogResponse.fromJson(Map<String, Object?> json) => _$PaginatedResponseAuditLogResponseFromJson(json);
}
