// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/location_waypoint_create.dart';
import '../models/location_waypoint_response.dart';
import '../models/navigation_session_create.dart';
import '../models/navigation_session_response.dart';
import '../models/reroute_request.dart';
import '../models/route_trace_response.dart';

part 'navigation_service.g.dart';

@RestApi()
abstract class NavigationService {
  factory NavigationService(Dio dio, {String? baseUrl}) = _NavigationService;

  /// Start Navigation.
  ///
  /// Start a new navigation session for a host.
  @POST('/api/v1/navigation/sessions')
  Future<NavigationSessionResponse> startNavigationApiV1NavigationSessionsPost({
    @Body() required NavigationSessionCreate body,
  });

  /// Get Active Session.
  ///
  /// Get the currently active navigation session for a host.
  @GET('/api/v1/navigation/sessions/active')
  Future<NavigationSessionResponse> getActiveSessionApiV1NavigationSessionsActiveGet({
    @Query('host_id') required String hostId,
  });

  /// Get Session.
  ///
  /// Get a navigation session by ID.
  @GET('/api/v1/navigation/sessions/{session_id}')
  Future<NavigationSessionResponse> getSessionApiV1NavigationSessionsSessionIdGet({
    @Path('session_id') required String sessionId,
  });

  /// Cancel Navigation.
  ///
  /// Cancel an active navigation session.
  @POST('/api/v1/navigation/sessions/{session_id}/cancel')
  Future<void> cancelNavigationApiV1NavigationSessionsSessionIdCancelPost({
    @Path('session_id') required String sessionId,
  });

  /// Reroute Navigation.
  ///
  /// Reroute a navigation session from the current location.
  @POST('/api/v1/navigation/sessions/{session_id}/reroute')
  Future<NavigationSessionResponse> rerouteNavigationApiV1NavigationSessionsSessionIdReroutePost({
    @Path('session_id') required String sessionId,
    @Body() required RerouteRequest body,
  });

  /// Create Waypoint.
  ///
  /// Record a single GPS waypoint.
  @POST('/api/v1/navigation/waypoints')
  Future<LocationWaypointResponse> createWaypointApiV1NavigationWaypointsPost({
    @Body() required LocationWaypointCreate body,
  });

  /// Create Waypoints Batch.
  ///
  /// Record multiple GPS waypoints in a batch.
  @POST('/api/v1/navigation/waypoints/batch')
  Future<List<LocationWaypointResponse>> createWaypointsBatchApiV1NavigationWaypointsBatchPost({
    @Body() required List<LocationWaypointCreate> body,
  });

  /// Get Host Location.
  ///
  /// Get the most recent location for a host (Concierge polling).
  @GET('/api/v1/navigation/location/{host_id}')
  Future<LocationWaypointResponse?> getHostLocationApiV1NavigationLocationHostIdGet({
    @Path('host_id') required String hostId,
  });

  /// Get Route Trace.
  ///
  /// Get waypoint trace for a navigation session (visualization).
  @GET('/api/v1/navigation/trace/{session_id}')
  Future<RouteTraceResponse> getRouteTraceApiV1NavigationTraceSessionIdGet({
    @Path('session_id') required String sessionId,
  });
}
