// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/medication_create.dart';
import '../models/medication_response.dart';
import '../models/medication_update.dart';
import '../models/paginated_response_medication_response.dart';

part 'medications_service.g.dart';

@RestApi()
abstract class MedicationsService {
  factory MedicationsService(Dio dio, {String? baseUrl}) = _MedicationsService;

  /// Create Medication.
  ///
  /// Create a medication schedule entry for a host.
  @POST('/api/v1/medications')
  Future<MedicationResponse> createMedicationApiV1MedicationsPost({
    @Body() required MedicationCreate body,
  });

  /// List Medications.
  ///
  /// List medications for a host (paginated, newest first).
  @GET('/api/v1/medications')
  Future<PaginatedResponseMedicationResponse> listMedicationsApiV1MedicationsGet({
    @Query('host_id') required String hostId,
    @Query('page') int? page = 1,
    @Query('limit') int? limit = 20,
  });

  /// Get Medication.
  ///
  /// Get a specific medication by ID.
  @GET('/api/v1/medications/{medication_id}')
  Future<MedicationResponse> getMedicationApiV1MedicationsMedicationIdGet({
    @Path('medication_id') required String medicationId,
  });

  /// Update Medication.
  ///
  /// Update a medication entry (e.g. mark as taken).
  @PATCH('/api/v1/medications/{medication_id}')
  Future<MedicationResponse> updateMedicationApiV1MedicationsMedicationIdPatch({
    @Path('medication_id') required String medicationId,
    @Body() required MedicationUpdate body,
  });

  /// Delete Medication.
  ///
  /// Delete a medication entry.
  @DELETE('/api/v1/medications/{medication_id}')
  Future<void> deleteMedicationApiV1MedicationsMedicationIdDelete({
    @Path('medication_id') required String medicationId,
  });
}
