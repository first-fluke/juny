import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/navigation/data/navigation_repository.dart';

/// {@template location_tracking_service}
/// Subscribes to the device GPS stream and periodically flushes
/// accumulated waypoints via [NavigationRepository.createWaypointsBatch].
///
/// Call [start] when a navigation session becomes active and [stop] when
/// it ends or the widget is disposed. Safe to call [stop] multiple times.
/// {@endtemplate}
class LocationTrackingService {
  /// {@macro location_tracking_service}
  LocationTrackingService({
    required NavigationRepository repository,
    required String hostId,
    required String sessionId,
    Duration flushInterval = const Duration(seconds: 8),
  }) : _repository = repository,
       _hostId = hostId,
       _sessionId = sessionId,
       _flushInterval = flushInterval;

  final NavigationRepository _repository;
  final String _hostId;
  final String _sessionId;
  final Duration _flushInterval;

  StreamSubscription<Position>? _positionSub;
  Timer? _flushTimer;
  final List<LocationWaypointCreate> _buffer = [];

  bool _running = false;

  /// Starts GPS subscription and the periodic flush loop.
  ///
  /// Returns false when location permission is denied.
  Future<bool> start() async {
    if (_running) return true;

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionSub = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(_onPosition);

    _flushTimer = Timer.periodic(_flushInterval, (_) => _flush());
    _running = true;
    return true;
  }

  /// Stops the GPS stream and flushes any remaining buffered waypoints.
  Future<void> stop() async {
    if (!_running) return;
    _running = false;
    await _positionSub?.cancel();
    _positionSub = null;
    _flushTimer?.cancel();
    _flushTimer = null;
    await _flush();
  }

  void _onPosition(Position pos) {
    _buffer.add(
      LocationWaypointCreate(
        hostId: _hostId,
        sessionId: _sessionId,
        lat: pos.latitude,
        lng: pos.longitude,
        altitude: pos.altitude,
        accuracy: pos.accuracy,
        speed: pos.speed,
        heading: pos.heading,
      ),
    );
  }

  Future<void> _flush() async {
    if (_buffer.isEmpty) return;
    final batch = List<LocationWaypointCreate>.from(_buffer);
    _buffer.clear();
    try {
      await _repository.createWaypointsBatch(waypoints: batch);
    } on Exception {
      // Re-queue on failure so waypoints are not silently dropped.
      _buffer.insertAll(0, batch);
    }
  }
}
