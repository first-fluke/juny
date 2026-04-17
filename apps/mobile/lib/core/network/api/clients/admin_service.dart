// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/cleanup_request.dart';
import '../models/cleanup_response.dart';
import '../models/inactive_relation_response.dart';
import '../models/paginated_response_audit_log_response.dart';
import '../models/token_deactivate_request.dart';
import '../models/token_deactivate_response.dart';
import '../models/wellness_aggregate_response.dart';

part 'admin_service.g.dart';

@RestApi()
abstract class AdminService {
  factory AdminService(Dio dio, {String? baseUrl}) = _AdminService;

  /// Cleanup Data.
  ///
  /// Clean up old data based on retention policy.
  @POST('/api/v1/admin/cleanup')
  Future<CleanupResponse> cleanupDataApiV1AdminCleanupPost({
    @Body() required CleanupRequest body,
  });

  /// List Inactive Relations.
  ///
  /// List care relations with no recent wellness activity.
  @GET('/api/v1/admin/inactive-relations')
  Future<List<InactiveRelationResponse>>
  listInactiveRelationsApiV1AdminInactiveRelationsGet({
    @Query('threshold_days') int? thresholdDays = 30,
  });

  /// Wellness Aggregate.
  ///
  /// Get daily wellness statistics for a host.
  @GET('/api/v1/admin/wellness/aggregate')
  Future<WellnessAggregateResponse>
  wellnessAggregateApiV1AdminWellnessAggregateGet({
    @Query('host_id') required String hostId,
    @Query('date') required String date,
  });

  /// Deactivate Tokens.
  ///
  /// Deactivate failed FCM tokens reported by the worker.
  @POST('/api/v1/admin/tokens/deactivate')
  Future<TokenDeactivateResponse>
  deactivateTokensApiV1AdminTokensDeactivatePost({
    @Body() required TokenDeactivateRequest body,
  });

  /// List Audit Logs.
  ///
  /// List audit log entries (paginated, newest first).
  @GET('/api/v1/admin/audit-logs')
  Future<PaginatedResponseAuditLogResponse>
  listAuditLogsApiV1AdminAuditLogsGet({
    @Query('page') int? page = 1,
    @Query('limit') int? limit = 50,
  });

  /// Export User Data.
  ///
  /// Export all data for a user (GDPR compliance).
  @GET('/api/v1/admin/export/{user_id}')
  Future<dynamic> exportUserDataApiV1AdminExportUserIdGet({
    @Path('user_id') required String userId,
  });
}
