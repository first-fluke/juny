import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/navigation/data/navigation_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockNavigationService extends Mock implements NavigationService {}

NavigationSessionResponse _session({String status = 'active'}) =>
    NavigationSessionResponse(
      id: 'nav-001',
      hostId: 'host-001',
      status: status,
      destinationName: 'Seoul Station',
      destinationLat: 37.5547,
      destinationLng: 126.9707,
      originLat: 37.5,
      originLng: 127,
      routeData: null,
      currentStepIndex: 0,
      createdAt: DateTime(2026),
      completedAt: null,
    );

LocationWaypointResponse _waypoint() => LocationWaypointResponse(
  id: 'wp-001',
  hostId: 'host-001',
  sessionId: 'nav-001',
  lat: 37.5,
  lng: 127,
  altitude: null,
  accuracy: 10,
  speed: null,
  heading: null,
  createdAt: DateTime(2026),
);

void main() {
  late _MockNavigationService mockService;
  late NavigationRepository sut;

  setUp(() {
    mockService = _MockNavigationService();
    sut = NavigationRepository(service: mockService);
    registerFallbackValue(
      const NavigationSessionCreate(
        hostId: 'x',
        destinationQuery: 'q',
        originLat: 0,
        originLng: 0,
      ),
    );
    registerFallbackValue(const RerouteRequest(currentLat: 0, currentLng: 0));
    registerFallbackValue(
      const LocationWaypointCreate(hostId: 'x', lat: 0, lng: 0),
    );
    registerFallbackValue(<LocationWaypointCreate>[]);
  });

  group('NavigationRepository', () {
    test('startSession posts NavigationSessionCreate', () async {
      when(
        () => mockService.startNavigationApiV1NavigationSessionsPost(
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => _session());

      await sut.startSession(
        hostId: 'host-001',
        destinationQuery: 'Seoul Station',
        originLat: 37.5,
        originLng: 127,
      );

      final captured =
          verify(
                () => mockService.startNavigationApiV1NavigationSessionsPost(
                  body: captureAny(named: 'body'),
                ),
              ).captured.single
              as NavigationSessionCreate;
      expect(captured.hostId, 'host-001');
      expect(captured.destinationQuery, 'Seoul Station');
      expect(captured.originLat, 37.5);
      expect(captured.originLng, 127);
    });

    test('getActiveSession delegates with host id', () async {
      final expected = _session();
      when(
        () => mockService.getActiveSessionApiV1NavigationSessionsActiveGet(
          hostId: any(named: 'hostId'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.getActiveSession(hostId: 'host-001');

      expect(result, expected);
    });

    test('cancelSession delegates with session id', () async {
      when(
        () => mockService
            .cancelNavigationApiV1NavigationSessionsSessionIdCancelPost(
              sessionId: any(named: 'sessionId'),
            ),
      ).thenAnswer((_) async {});

      await sut.cancelSession('nav-001');

      verify(
        () => mockService
            .cancelNavigationApiV1NavigationSessionsSessionIdCancelPost(
              sessionId: 'nav-001',
            ),
      ).called(1);
    });

    test('rerouteSession posts RerouteRequest', () async {
      when(
        () => mockService
            .rerouteNavigationApiV1NavigationSessionsSessionIdReroutePost(
              sessionId: any(named: 'sessionId'),
              body: any(named: 'body'),
            ),
      ).thenAnswer((_) async => _session());

      await sut.rerouteSession(
        sessionId: 'nav-001',
        currentLat: 37.6,
        currentLng: 127.1,
      );

      verify(
        () => mockService
            .rerouteNavigationApiV1NavigationSessionsSessionIdReroutePost(
              sessionId: 'nav-001',
              body: const RerouteRequest(currentLat: 37.6, currentLng: 127.1),
            ),
      ).called(1);
    });

    test('createWaypoint posts waypoint', () async {
      const waypoint = LocationWaypointCreate(
        hostId: 'host-001',
        lat: 37.5,
        lng: 127,
      );
      when(
        () => mockService.createWaypointApiV1NavigationWaypointsPost(
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => _waypoint());

      await sut.createWaypoint(waypoint: waypoint);

      verify(
        () => mockService.createWaypointApiV1NavigationWaypointsPost(
          body: waypoint,
        ),
      ).called(1);
    });

    test('createWaypointsBatch posts waypoint list', () async {
      const waypoints = [
        LocationWaypointCreate(hostId: 'host-001', lat: 37.5, lng: 127),
      ];
      when(
        () => mockService.createWaypointsBatchApiV1NavigationWaypointsBatchPost(
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => [_waypoint()]);

      final result = await sut.createWaypointsBatch(waypoints: waypoints);

      expect(result, hasLength(1));
      verify(
        () => mockService.createWaypointsBatchApiV1NavigationWaypointsBatchPost(
          body: waypoints,
        ),
      ).called(1);
    });

    test('getHostLocation returns null when no data', () async {
      when(
        () => mockService.getHostLocationApiV1NavigationLocationHostIdGet(
          hostId: any(named: 'hostId'),
        ),
      ).thenAnswer((_) async => null);

      final result = await sut.getHostLocation('host-001');

      expect(result, isNull);
    });

    test('getRouteTrace delegates with session id', () async {
      final expected = RouteTraceResponse(
        hostId: 'host-001',
        sessionId: 'nav-001',
        waypoints: [_waypoint()],
        totalDistanceMeters: 1000,
        durationSeconds: 600,
      );
      when(
        () => mockService.getRouteTraceApiV1NavigationTraceSessionIdGet(
          sessionId: any(named: 'sessionId'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.getRouteTrace('nav-001');

      expect(result, expected);
    });
  });
}
