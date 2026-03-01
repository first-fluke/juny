// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response_audit_log_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedResponseAuditLogResponse _$PaginatedResponseAuditLogResponseFromJson(
  Map<String, dynamic> json,
) => _PaginatedResponseAuditLogResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => AuditLogResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaginatedResponseAuditLogResponseToJson(
  _PaginatedResponseAuditLogResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
