// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/paginated_response_wellness_log_response.dart';
import '../models/wellness_log_create.dart';
import '../models/wellness_log_response.dart';

part 'wellness_service.g.dart';

@RestApi()
abstract class WellnessService {
  factory WellnessService(Dio dio, {String? baseUrl}) = _WellnessService;

  /// Create Wellness Log.
  ///
  /// Create a wellness log entry for a host.
  @POST('/api/v1/wellness')
  Future<WellnessLogResponse> createWellnessLogApiV1WellnessPost({
    @Body() required WellnessLogCreate body,
  });

  /// List Wellness Logs.
  ///
  /// List wellness logs for a host (paginated, newest first).
  @GET('/api/v1/wellness')
  Future<PaginatedResponseWellnessLogResponse> listWellnessLogsApiV1WellnessGet({
    @Query('host_id') required String hostId,
    @Query('page') int? page = 1,
    @Query('limit') int? limit = 20,
  });

  /// Get Wellness Log.
  ///
  /// Get a specific wellness log by ID.
  @GET('/api/v1/wellness/{log_id}')
  Future<WellnessLogResponse> getWellnessLogApiV1WellnessLogIdGet({
    @Path('log_id') required String logId,
  });
}
