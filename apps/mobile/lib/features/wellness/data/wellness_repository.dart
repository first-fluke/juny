import 'package:mobile/core/network/api/export.dart';

/// {@template wellness_repository}
/// Data layer for wellness log operations.
/// {@endtemplate}
class WellnessRepository {
  /// {@macro wellness_repository}
  WellnessRepository({required WellnessService service}) : _service = service;

  final WellnessService _service;

  Future<PaginatedResponseWellnessLogResponse> list({
    required String hostId,
    int page = 1,
    int limit = 20,
  }) => _service.listWellnessLogsApiV1WellnessGet(
    hostId: hostId,
    page: page,
    limit: limit,
  );

  Future<WellnessLogResponse> get(String id) =>
      _service.getWellnessLogApiV1WellnessLogIdGet(logId: id);

  Future<WellnessLogResponse> create({
    required String hostId,
    required WellnessStatus status,
    required String summary,
  }) => _service.createWellnessLogApiV1WellnessPost(
    body: WellnessLogCreate(
      hostId: hostId,
      status: status,
      summary: summary,
    ),
  );
}
