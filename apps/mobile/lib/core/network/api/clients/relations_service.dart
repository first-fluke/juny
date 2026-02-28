// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/care_relation_create.dart';
import '../models/care_relation_response.dart';
import '../models/care_relation_update.dart';
import '../models/paginated_response_care_relation_response.dart';

part 'relations_service.g.dart';

@RestApi()
abstract class RelationsService {
  factory RelationsService(Dio dio, {String? baseUrl}) = _RelationsService;

  /// Create Care Relation.
  ///
  /// Create a new care relation between host and caregiver.
  ///
  /// Only the host or an existing caregiver of the host may create new relations.
  @POST('/api/v1/relations')
  Future<CareRelationResponse> createCareRelationApiV1RelationsPost({
    @Body() required CareRelationCreate body,
  });

  /// List Care Relations.
  ///
  /// List care relations filtered by host or caregiver.
  ///
  /// Users can only list relations they participate in.
  @GET('/api/v1/relations')
  Future<PaginatedResponseCareRelationResponse> listCareRelationsApiV1RelationsGet({
    @Query('active_only') bool? activeOnly = true,
    @Query('page') int? page = 1,
    @Query('limit') int? limit = 20,
    @Query('host_id') String? hostId,
    @Query('caregiver_id') String? caregiverId,
  });

  /// Get Care Relation.
  ///
  /// Get a specific care relation by ID.
  @GET('/api/v1/relations/{relation_id}')
  Future<CareRelationResponse> getCareRelationApiV1RelationsRelationIdGet({
    @Path('relation_id') required String relationId,
  });

  /// Update Care Relation.
  ///
  /// Update a care relation (e.g. deactivate, change role).
  @PATCH('/api/v1/relations/{relation_id}')
  Future<CareRelationResponse> updateCareRelationApiV1RelationsRelationIdPatch({
    @Path('relation_id') required String relationId,
    @Body() required CareRelationUpdate body,
  });

  /// Delete Care Relation.
  ///
  /// Delete a care relation.
  @DELETE('/api/v1/relations/{relation_id}')
  Future<void> deleteCareRelationApiV1RelationsRelationIdDelete({
    @Path('relation_id') required String relationId,
  });
}
