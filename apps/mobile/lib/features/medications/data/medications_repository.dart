import 'package:mobile/core/network/api/export.dart';

/// {@template medications_repository}
/// Data layer for medication CRUD operations.
/// {@endtemplate}
class MedicationsRepository {
  /// {@macro medications_repository}
  MedicationsRepository({required MedicationsService service})
    : _service = service;

  final MedicationsService _service;

  Future<PaginatedResponseMedicationResponse> list({
    required String hostId,
    int page = 1,
    int limit = 20,
  }) => _service.listMedicationsApiV1MedicationsGet(
    hostId: hostId,
    page: page,
    limit: limit,
  );

  Future<MedicationResponse> get(String id) =>
      _service.getMedicationApiV1MedicationsMedicationIdGet(medicationId: id);

  Future<MedicationResponse> create({
    required String hostId,
    required String pillName,
    required DateTime scheduleTime,
  }) => _service.createMedicationApiV1MedicationsPost(
    body: MedicationCreate(
      hostId: hostId,
      pillName: pillName,
      scheduleTime: scheduleTime,
    ),
  );

  Future<MedicationResponse> markAsTaken(String id) =>
      _service.updateMedicationApiV1MedicationsMedicationIdPatch(
        medicationId: id,
        body: const MedicationUpdate(isTaken: true),
      );

  Future<void> delete(String id) =>
      _service.deleteMedicationApiV1MedicationsMedicationIdDelete(
        medicationId: id,
      );
}
