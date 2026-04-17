import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/notifications/data/notification_logs_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotificationLogsService extends Mock
    implements NotificationLogsService {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

PaginationMeta _buildMeta({int page = 1, int total = 0}) => PaginationMeta(
  page: page,
  limit: 20,
  total: total,
  totalPages: (total / 20).ceil(),
  hasNext: false,
  hasPrev: false,
);

NotificationLogResponse _buildLog({
  String id = 'log-001',
  String status = 'delivered',
}) => NotificationLogResponse(
  id: id,
  recipientId: 'user-001',
  title: 'Test notification',
  body: 'Body text',
  status: status,
  channel: 'push',
  metadata: null,
  createdAt: DateTime(2024),
);

void main() {
  late _MockNotificationLogsService mockService;
  late NotificationLogsRepository sut;

  setUp(() {
    mockService = _MockNotificationLogsService();
    sut = NotificationLogsRepository(notificationLogsService: mockService);
    registerFallbackValue(
      const NotificationLogStatusUpdate(status: 'read'),
    );
  });

  group('NotificationLogsRepository', () {
    group('listLogs', () {
      test(
        'returns paginated response from service with default params',
        () async {
          final expected = PaginatedResponseNotificationLogResponse(
            data: [_buildLog()],
            meta: _buildMeta(total: 1),
          );
          when(
            () => mockService.listNotificationLogsApiV1NotificationLogsGet(
              page: any(named: 'page'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => expected);

          final result = await sut.listLogs();

          expect(result, expected);
          verify(
            () => mockService.listNotificationLogsApiV1NotificationLogsGet(
              page: any(named: 'page'),
              limit: any(named: 'limit'),
            ),
          ).called(1);
        },
      );

      test('passes custom page and limit to service', () async {
        final expected = PaginatedResponseNotificationLogResponse(
          data: const [],
          meta: _buildMeta(page: 3),
        );
        when(
          () => mockService.listNotificationLogsApiV1NotificationLogsGet(
            page: 3,
            limit: 10,
          ),
        ).thenAnswer((_) async => expected);

        final result = await sut.listLogs(page: 3, limit: 10);

        expect(result, expected);
        verify(
          () => mockService.listNotificationLogsApiV1NotificationLogsGet(
            page: 3,
            limit: 10,
          ),
        ).called(1);
      });

      test('propagates exceptions from service', () async {
        when(
          () => mockService.listNotificationLogsApiV1NotificationLogsGet(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => throw Exception('network error'));

        await expectLater(sut.listLogs(), throwsA(isA<Exception>()));
      });

      test('returns empty data list when service returns no items', () async {
        final expected = PaginatedResponseNotificationLogResponse(
          data: const [],
          meta: _buildMeta(),
        );
        when(
          () => mockService.listNotificationLogsApiV1NotificationLogsGet(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => expected);

        final result = await sut.listLogs();

        expect(result.data, isEmpty);
        expect(result.meta.total, 0);
      });
    });

    group('markAsRead', () {
      test(
        'delegates to service with correct logId and read status',
        () async {
          final updatedLog = _buildLog(status: 'read');
          when(
            () => mockService
                .updateLogStatusApiV1NotificationLogsLogIdStatusPatch(
                  logId: 'log-001',
                  body: any(named: 'body'),
                ),
          ).thenAnswer((_) async => updatedLog);

          final result = await sut.markAsRead('log-001');

          expect(result, updatedLog);
          expect(result.status, 'read');
          verify(
            () => mockService
                .updateLogStatusApiV1NotificationLogsLogIdStatusPatch(
                  logId: 'log-001',
                  body: const NotificationLogStatusUpdate(status: 'read'),
                ),
          ).called(1);
        },
      );

      test('propagates exceptions from service', () async {
        when(
          () =>
              mockService.updateLogStatusApiV1NotificationLogsLogIdStatusPatch(
                logId: any(named: 'logId'),
                body: any(named: 'body'),
              ),
        ).thenAnswer((_) async => throw Exception('update failed'));

        await expectLater(
          sut.markAsRead('log-001'),
          throwsA(isA<Exception>()),
        );
      });

      test('passes the correct status value "read" to service', () async {
        when(
          () =>
              mockService.updateLogStatusApiV1NotificationLogsLogIdStatusPatch(
                logId: any(named: 'logId'),
                body: any(named: 'body'),
              ),
        ).thenAnswer((_) async => _buildLog(status: 'read'));

        await sut.markAsRead('log-002');

        final captured =
            verify(
                  () => mockService
                      .updateLogStatusApiV1NotificationLogsLogIdStatusPatch(
                        logId: 'log-002',
                        body: captureAny(named: 'body'),
                      ),
                ).captured.single
                as NotificationLogStatusUpdate;

        expect(captured.status, 'read');
      });
    });
  });
}
