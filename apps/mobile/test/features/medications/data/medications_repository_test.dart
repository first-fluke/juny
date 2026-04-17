import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/medications/data/medications_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockMedicationsService extends Mock implements MedicationsService {}

PaginationMeta _meta({int page = 1, int total = 0}) => PaginationMeta(
  page: page,
  limit: 20,
  total: total,
  totalPages: (total / 20).ceil(),
  hasNext: false,
  hasPrev: false,
);

MedicationResponse _medication({
  String id = 'med-001',
  bool isTaken = false,
}) => MedicationResponse(
  id: id,
  hostId: 'host-001',
  pillName: 'Vitamin D',
  scheduleTime: DateTime(2026),
  isTaken: isTaken,
  createdAt: DateTime(2026),
);

void main() {
  late _MockMedicationsService mockService;
  late MedicationsRepository sut;

  setUp(() {
    mockService = _MockMedicationsService();
    sut = MedicationsRepository(service: mockService);
    registerFallbackValue(
      MedicationCreate(
        hostId: 'host-001',
        pillName: 'x',
        scheduleTime: DateTime(2026),
      ),
    );
    registerFallbackValue(const MedicationUpdate(isTaken: true));
  });

  group('MedicationsRepository', () {
    test('list delegates with default pagination', () async {
      final expected = PaginatedResponseMedicationResponse(
        data: [_medication()],
        meta: _meta(total: 1),
      );
      when(
        () => mockService.listMedicationsApiV1MedicationsGet(
          hostId: any(named: 'hostId'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.list(hostId: 'host-001');

      expect(result, expected);
      verify(
        () => mockService.listMedicationsApiV1MedicationsGet(
          hostId: 'host-001',
        ),
      ).called(1);
    });

    test('get delegates with medication id', () async {
      final expected = _medication();
      when(
        () => mockService.getMedicationApiV1MedicationsMedicationIdGet(
          medicationId: any(named: 'medicationId'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.get('med-001');

      expect(result, expected);
      verify(
        () => mockService.getMedicationApiV1MedicationsMedicationIdGet(
          medicationId: 'med-001',
        ),
      ).called(1);
    });

    test('create posts the MedicationCreate payload', () async {
      final scheduled = DateTime(2026, 6);
      when(
        () => mockService.createMedicationApiV1MedicationsPost(
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => _medication());

      await sut.create(
        hostId: 'host-001',
        pillName: 'Aspirin',
        scheduleTime: scheduled,
      );

      final captured =
          verify(
                () => mockService.createMedicationApiV1MedicationsPost(
                  body: captureAny(named: 'body'),
                ),
              ).captured.single
              as MedicationCreate;
      expect(captured.hostId, 'host-001');
      expect(captured.pillName, 'Aspirin');
      expect(captured.scheduleTime, scheduled);
    });

    test('markAsTaken sends isTaken=true', () async {
      when(
        () => mockService.updateMedicationApiV1MedicationsMedicationIdPatch(
          medicationId: any(named: 'medicationId'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => _medication(isTaken: true));

      final result = await sut.markAsTaken('med-001');

      expect(result.isTaken, isTrue);
      verify(
        () => mockService.updateMedicationApiV1MedicationsMedicationIdPatch(
          medicationId: 'med-001',
          body: const MedicationUpdate(isTaken: true),
        ),
      ).called(1);
    });

    test('delete delegates with medication id', () async {
      when(
        () => mockService.deleteMedicationApiV1MedicationsMedicationIdDelete(
          medicationId: any(named: 'medicationId'),
        ),
      ).thenAnswer((_) async {});

      await sut.delete('med-001');

      verify(
        () => mockService.deleteMedicationApiV1MedicationsMedicationIdDelete(
          medicationId: 'med-001',
        ),
      ).called(1);
    });

    test('adherence delegates with date range', () async {
      final from = DateTime(2026);
      final to = DateTime(2026, 2);
      const expected = MedicationAdherenceResponse(
        hostId: 'host-001',
        dateFrom: '2026-01-01',
        dateTo: '2026-02-01',
        total: 10,
        taken: 8,
        missed: 2,
        adherenceRate: 0.8,
      );
      when(
        () => mockService.getMedicationAdherenceApiV1MedicationsAdherenceGet(
          hostId: any(named: 'hostId'),
          dateFrom: any(named: 'dateFrom'),
          dateTo: any(named: 'dateTo'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.adherence(
        hostId: 'host-001',
        dateFrom: from,
        dateTo: to,
      );

      expect(result, expected);
      verify(
        () => mockService.getMedicationAdherenceApiV1MedicationsAdherenceGet(
          hostId: 'host-001',
          dateFrom: from,
          dateTo: to,
        ),
      ).called(1);
    });

    test('propagates exceptions from service', () async {
      when(
        () => mockService.listMedicationsApiV1MedicationsGet(
          hostId: any(named: 'hostId'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => throw Exception('network error'));

      await expectLater(
        sut.list(hostId: 'host-001'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
