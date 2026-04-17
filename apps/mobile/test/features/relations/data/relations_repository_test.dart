import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/relations/data/relations_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockRelationsService extends Mock implements RelationsService {}

PaginationMeta _meta({int total = 0}) => PaginationMeta(
  page: 1,
  limit: 20,
  total: total,
  totalPages: (total / 20).ceil(),
  hasNext: false,
  hasPrev: false,
);

CareRelationResponse _relation({bool isActive = true}) => CareRelationResponse(
  id: 'rel-001',
  hostId: 'host-001',
  caregiverId: 'caregiver-001',
  role: 'concierge',
  isActive: isActive,
  createdAt: DateTime(2026),
);

void main() {
  late _MockRelationsService mockService;
  late RelationsRepository sut;

  setUp(() {
    mockService = _MockRelationsService();
    sut = RelationsRepository(service: mockService);
    registerFallbackValue(
      const CareRelationCreate(hostId: 'x', caregiverId: 'y', role: 'z'),
    );
    registerFallbackValue(const CareRelationUpdate(isActive: false));
  });

  group('RelationsRepository', () {
    test('list delegates with defaults (activeOnly=true)', () async {
      final expected = PaginatedResponseCareRelationResponse(
        data: [_relation()],
        meta: _meta(total: 1),
      );
      when(
        () => mockService.listCareRelationsApiV1RelationsGet(
          activeOnly: any(named: 'activeOnly'),
          hostId: any(named: 'hostId'),
          caregiverId: any(named: 'caregiverId'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.list();

      expect(result, expected);
      verify(
        () => mockService.listCareRelationsApiV1RelationsGet(),
      ).called(1);
    });

    test('list passes through filter parameters', () async {
      when(
        () => mockService.listCareRelationsApiV1RelationsGet(
          activeOnly: any(named: 'activeOnly'),
          hostId: any(named: 'hostId'),
          caregiverId: any(named: 'caregiverId'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => PaginatedResponseCareRelationResponse(
          data: const [],
          meta: _meta(),
        ),
      );

      await sut.list(
        activeOnly: false,
        hostId: 'host-001',
        caregiverId: 'caregiver-001',
        page: 3,
        limit: 50,
      );

      verify(
        () => mockService.listCareRelationsApiV1RelationsGet(
          activeOnly: false,
          hostId: 'host-001',
          caregiverId: 'caregiver-001',
          page: 3,
          limit: 50,
        ),
      ).called(1);
    });

    test('create posts CareRelationCreate payload', () async {
      when(
        () => mockService.createCareRelationApiV1RelationsPost(
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => _relation());

      await sut.create(
        hostId: 'host-001',
        caregiverId: 'caregiver-001',
        role: 'concierge',
      );

      final captured =
          verify(
                () => mockService.createCareRelationApiV1RelationsPost(
                  body: captureAny(named: 'body'),
                ),
              ).captured.single
              as CareRelationCreate;
      expect(captured.hostId, 'host-001');
      expect(captured.caregiverId, 'caregiver-001');
      expect(captured.role, 'concierge');
    });

    test('deactivate sends isActive=false', () async {
      when(
        () => mockService.updateCareRelationApiV1RelationsRelationIdPatch(
          relationId: any(named: 'relationId'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => _relation(isActive: false));

      final result = await sut.deactivate('rel-001');

      expect(result.isActive, isFalse);
      verify(
        () => mockService.updateCareRelationApiV1RelationsRelationIdPatch(
          relationId: 'rel-001',
          body: const CareRelationUpdate(isActive: false),
        ),
      ).called(1);
    });

    test('delete delegates with id', () async {
      when(
        () => mockService.deleteCareRelationApiV1RelationsRelationIdDelete(
          relationId: any(named: 'relationId'),
        ),
      ).thenAnswer((_) async {});

      await sut.delete('rel-001');

      verify(
        () => mockService.deleteCareRelationApiV1RelationsRelationIdDelete(
          relationId: 'rel-001',
        ),
      ).called(1);
    });
  });
}
