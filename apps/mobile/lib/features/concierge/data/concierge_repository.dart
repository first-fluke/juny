import 'package:mobile/core/network/api/export.dart';

/// {@template host_summary}
/// Aggregated status snapshot for a single host managed by the concierge.
/// {@endtemplate}
class HostSummary {
  /// {@macro host_summary}
  const HostSummary({
    required this.relation,
    this.latestWellness,
    this.pendingMedications,
    this.activeNavigation,
  });

  /// The care relation this summary belongs to.
  final CareRelationResponse relation;

  /// The most recent wellness log, or null if none exist.
  final WellnessLogResponse? latestWellness;

  /// Number of medications not yet taken today.
  final int? pendingMedications;

  /// Active navigation session, or null when not navigating.
  final NavigationSessionResponse? activeNavigation;
}

/// {@template concierge_repository}
/// Aggregates host data for the concierge dashboard.
///
/// Fetches care relations for the current concierge user, then
/// resolves the latest wellness log, medication status, and navigation
/// session for each managed host.
/// {@endtemplate}
class ConciergeRepository {
  /// {@macro concierge_repository}
  const ConciergeRepository({
    required RelationsService relationsService,
    required WellnessService wellnessService,
    required MedicationsService medicationsService,
    required NavigationService navigationService,
  }) : _relationsService = relationsService,
       _wellnessService = wellnessService,
       _medicationsService = medicationsService,
       _navigationService = navigationService;

  final RelationsService _relationsService;
  final WellnessService _wellnessService;
  final MedicationsService _medicationsService;
  final NavigationService _navigationService;

  /// Returns a list of [HostSummary] for every active host relation.
  Future<List<HostSummary>> listHostSummaries({
    required String caregiverId,
  }) async {
    final relations = await _relationsService
        .listCareRelationsApiV1RelationsGet(
          caregiverId: caregiverId,
        );

    final summaries = await Future.wait(
      relations.data.map(_buildSummary),
    );
    return summaries;
  }

  Future<HostSummary> _buildSummary(CareRelationResponse relation) async {
    final hostId = relation.hostId;

    final results = await Future.wait([
      _fetchLatestWellness(hostId),
      _fetchPendingMedications(hostId),
      _fetchActiveNavigation(hostId),
    ]);

    return HostSummary(
      relation: relation,
      latestWellness: results[0] as WellnessLogResponse?,
      pendingMedications: results[1] as int?,
      activeNavigation: results[2] as NavigationSessionResponse?,
    );
  }

  Future<WellnessLogResponse?> _fetchLatestWellness(String hostId) async {
    try {
      final response = await _wellnessService.listWellnessLogsApiV1WellnessGet(
        hostId: hostId,
        limit: 1,
      );
      return response.data.firstOrNull;
    } on Exception {
      return null;
    }
  }

  Future<int?> _fetchPendingMedications(String hostId) async {
    try {
      final response = await _medicationsService
          .listMedicationsApiV1MedicationsGet(
            hostId: hostId,
            limit: 50,
          );
      return response.data.where((m) => !m.isTaken).length;
    } on Exception {
      return null;
    }
  }

  Future<NavigationSessionResponse?> _fetchActiveNavigation(
    String hostId,
  ) async {
    try {
      return await _navigationService
          .getActiveSessionApiV1NavigationSessionsActiveGet(hostId: hostId);
    } on Exception {
      return null;
    }
  }
}
