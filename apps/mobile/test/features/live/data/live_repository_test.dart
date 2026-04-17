import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/live/data/live_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockLiveService extends Mock implements LiveService {}

void main() {
  late _MockLiveService mockService;
  late LiveRepository sut;

  setUp(() {
    mockService = _MockLiveService();
    sut = LiveRepository(liveService: mockService);
    registerFallbackValue(Role.host);
  });

  group('LiveRepository.getToken', () {
    test('delegates roomName and role to service', () async {
      const expected = LiveTokenResponse(
        token: 'jwt.token.value',
        roomName: 'room-001',
        identity: 'user-host',
        role: LiveTokenResponseRole.host,
      );
      when(
        () => mockService.getLiveTokenApiV1LiveTokenGet(
          roomName: any(named: 'roomName'),
          role: any(named: 'role'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.getToken(
        roomName: 'room-001',
        role: Role.host,
      );

      expect(result, expected);
      verify(
        () => mockService.getLiveTokenApiV1LiveTokenGet(
          roomName: 'room-001',
          role: Role.host,
        ),
      ).called(1);
    });

    test('propagates service exceptions', () async {
      when(
        () => mockService.getLiveTokenApiV1LiveTokenGet(
          roomName: any(named: 'roomName'),
          role: any(named: 'role'),
        ),
      ).thenAnswer((_) async => throw Exception('unauthorized'));

      await expectLater(
        sut.getToken(roomName: 'room-001', role: Role.concierge),
        throwsA(isA<Exception>()),
      );
    });
  });
}
