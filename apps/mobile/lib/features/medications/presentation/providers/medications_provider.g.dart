// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(medicationsRepository)
final medicationsRepositoryProvider = MedicationsRepositoryProvider._();

final class MedicationsRepositoryProvider
    extends
        $FunctionalProvider<
          MedicationsRepository,
          MedicationsRepository,
          MedicationsRepository
        >
    with $Provider<MedicationsRepository> {
  MedicationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicationsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<MedicationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MedicationsRepository create(Ref ref) {
    return medicationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MedicationsRepository>(value),
    );
  }
}

String _$medicationsRepositoryHash() =>
    r'12eff6317e1749e238bb8af25a7ae467f1278371';

@ProviderFor(medicationsList)
final medicationsListProvider = MedicationsListFamily._();

final class MedicationsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedResponseMedicationResponse>,
          PaginatedResponseMedicationResponse,
          FutureOr<PaginatedResponseMedicationResponse>
        >
    with
        $FutureModifier<PaginatedResponseMedicationResponse>,
        $FutureProvider<PaginatedResponseMedicationResponse> {
  MedicationsListProvider._({
    required MedicationsListFamily super.from,
    required ({String hostId, int page}) super.argument,
  }) : super(
         retry: null,
         name: r'medicationsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$medicationsListHash();

  @override
  String toString() {
    return r'medicationsListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PaginatedResponseMedicationResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedResponseMedicationResponse> create(Ref ref) {
    final argument = this.argument as ({String hostId, int page});
    return medicationsList(ref, hostId: argument.hostId, page: argument.page);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicationsListHash() => r'd7a4ed48ffc68e530e7c6b73098cf0c1e3cf66ad';

final class MedicationsListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PaginatedResponseMedicationResponse>,
          ({String hostId, int page})
        > {
  MedicationsListFamily._()
    : super(
        retry: null,
        name: r'medicationsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MedicationsListProvider call({required String hostId, int page = 1}) =>
      MedicationsListProvider._(
        argument: (hostId: hostId, page: page),
        from: this,
      );

  @override
  String toString() => r'medicationsListProvider';
}
