import 'package:mobile/core/network/api/export.dart';

/// {@template navigation_repository}
/// Data layer for navigation session and waypoint operations.
/// {@endtemplate}
class NavigationRepository {
  /// {@macro navigation_repository}
  NavigationRepository({required NavigationService service})
    : _service = service;

  final NavigationService _service;

  Future<NavigationSessionResponse> startSession({
    required String hostId,
    required String destinationQuery,
    required num originLat,
    required num originLng,
  }) => _service.startNavigationApiV1NavigationSessionsPost(
    body: NavigationSessionCreate(
      hostId: hostId,
      destinationQuery: destinationQuery,
      originLat: originLat,
      originLng: originLng,
    ),
  );

  Future<NavigationSessionResponse> getActiveSession({
    required String hostId,
  }) => _service.getActiveSessionApiV1NavigationSessionsActiveGet(
    hostId: hostId,
  );

  Future<NavigationSessionResponse> getSession(String sessionId) =>
      _service.getSessionApiV1NavigationSessionsSessionIdGet(
        sessionId: sessionId,
      );

  Future<void> cancelSession(String sessionId) =>
      _service.cancelNavigationApiV1NavigationSessionsSessionIdCancelPost(
        sessionId: sessionId,
      );

  Future<NavigationSessionResponse> rerouteSession({
    required String sessionId,
    required num currentLat,
    required num currentLng,
  }) => _service.rerouteNavigationApiV1NavigationSessionsSessionIdReroutePost(
    sessionId: sessionId,
    body: RerouteRequest(currentLat: currentLat, currentLng: currentLng),
  );

  Future<LocationWaypointResponse> createWaypoint({
    required LocationWaypointCreate waypoint,
  }) => _service.createWaypointApiV1NavigationWaypointsPost(body: waypoint);

  Future<List<LocationWaypointResponse>> createWaypointsBatch({
    required List<LocationWaypointCreate> waypoints,
  }) => _service.createWaypointsBatchApiV1NavigationWaypointsBatchPost(
    body: waypoints,
  );

  Future<LocationWaypointResponse?> getHostLocation(String hostId) =>
      _service.getHostLocationApiV1NavigationLocationHostIdGet(hostId: hostId);

  Future<RouteTraceResponse> getRouteTrace(String sessionId) =>
      _service.getRouteTraceApiV1NavigationTraceSessionIdGet(
        sessionId: sessionId,
      );
}
