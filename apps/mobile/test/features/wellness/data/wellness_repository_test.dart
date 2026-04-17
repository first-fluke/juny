import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/wellness/data/wellness_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockWellnessService extends Mock implements WellnessService {}

PaginationMeta _meta({int total = 0}) => PaginationMeta(
  page: 1,
  limit: 20,
  total: total,
  totalPages: (total / 20).ceil(),
  hasNext: false,
  hasPrev: false,
);

WellnessLogResponse _log({String id = 'log-001'}) => WellnessLogResponse(
  id: id,
  hostId: 'host-001',
  status: 'normal',
  summary: '오늘 컨디션 양호',
  details: null,
  createdAt: DateTime(2026),
);

void main() {
  late _MockWellnessService mockService;
  late WellnessRepository sut;

  setUp(() {
    mockService = _MockWellnessService();
    sut = WellnessRepository(service: mockService);
    registerFallbackValue(
      const WellnessLogCreate(
        hostId: 'x',
        status: WellnessStatus.normal,
        summary: 'x',
      ),
    );
  });

  group('WellnessRepository', () {
    test('list delegates with default pagination', () async {
      final expected = PaginatedResponseWellnessLogResponse(
        data: [_log()],
        meta: _meta(total: 1),
      );
      when(
        () => mockService.listWellnessLogsApiV1WellnessGet(
          hostId: any(named: 'hostId'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.list(hostId: 'host-001');

      expect(result, expected);
      verify(
        () => mockService.listWellnessLogsApiV1WellnessGet(
          hostId: 'host-001',
        ),
      ).called(1);
    });

    test('get delegates with log id', () async {
      final expected = _log();
      when(
        () => mockService.getWellnessLogApiV1WellnessLogIdGet(
          logId: any(named: 'logId'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.get('log-001');

      expect(result, expected);
      verify(
        () => mockService.getWellnessLogApiV1WellnessLogIdGet(
          logId: 'log-001',
        ),
      ).called(1);
    });

    test('create posts WellnessLogCreate payload', () async {
      when(
        () => mockService.createWellnessLogApiV1WellnessPost(
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => _log());

      await sut.create(
        hostId: 'host-001',
        status: WellnessStatus.warning,
        summary: '혈압 상승',
      );

      final captured =
          verify(
                () => mockService.createWellnessLogApiV1WellnessPost(
                  body: captureAny(named: 'body'),
                ),
              ).captured.single
              as WellnessLogCreate;
      expect(captured.hostId, 'host-001');
      expect(captured.status, WellnessStatus.warning);
      expect(captured.summary, '혈압 상승');
    });

    test('trends delegates with date range', () async {
      final from = DateTime(2026);
      final to = DateTime(2026, 2);
      const expected = WellnessTrendResponse(
        hostId: 'host-001',
        dateFrom: '2026-01-01',
        dateTo: '2026-02-01',
        dailyStats: [],
      );
      when(
        () => mockService.getWellnessTrendApiV1WellnessTrendsGet(
          hostId: any(named: 'hostId'),
          dateFrom: any(named: 'dateFrom'),
          dateTo: any(named: 'dateTo'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.trends(
        hostId: 'host-001',
        dateFrom: from,
        dateTo: to,
      );

      expect(result, expected);
    });

    test('propagates service exceptions', () async {
      when(
        () => mockService.listWellnessLogsApiV1WellnessGet(
          hostId: any(named: 'hostId'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => throw Exception('boom'));

      await expectLater(
        sut.list(hostId: 'host-001'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
