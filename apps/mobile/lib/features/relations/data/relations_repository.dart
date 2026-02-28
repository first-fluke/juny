import 'package:mobile/core/network/api/export.dart';

/// {@template relations_repository}
/// Data layer for care relation operations.
/// {@endtemplate}
class RelationsRepository {
  /// {@macro relations_repository}
  RelationsRepository({required RelationsService service}) : _service = service;

  final RelationsService _service;

  Future<PaginatedResponseCareRelationResponse> list({
    bool activeOnly = true,
    String? hostId,
    String? caregiverId,
    int page = 1,
    int limit = 20,
  }) => _service.listCareRelationsApiV1RelationsGet(
    activeOnly: activeOnly,
    hostId: hostId,
    caregiverId: caregiverId,
    page: page,
    limit: limit,
  );

  Future<CareRelationResponse> get(String id) =>
      _service.getCareRelationApiV1RelationsRelationIdGet(relationId: id);

  Future<CareRelationResponse> create({
    required String hostId,
    required String caregiverId,
    required String role,
  }) => _service.createCareRelationApiV1RelationsPost(
    body: CareRelationCreate(
      hostId: hostId,
      caregiverId: caregiverId,
      role: role,
    ),
  );

  Future<CareRelationResponse> deactivate(String id) =>
      _service.updateCareRelationApiV1RelationsRelationIdPatch(
        relationId: id,
        body: const CareRelationUpdate(isActive: false),
      );

  Future<void> delete(String id) =>
      _service.deleteCareRelationApiV1RelationsRelationIdDelete(
        relationId: id,
      );
}
