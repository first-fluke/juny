// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relations_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(relationsRepository)
final relationsRepositoryProvider = RelationsRepositoryProvider._();

final class RelationsRepositoryProvider
    extends
        $FunctionalProvider<
          RelationsRepository,
          RelationsRepository,
          RelationsRepository
        >
    with $Provider<RelationsRepository> {
  RelationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'relationsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$relationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<RelationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RelationsRepository create(Ref ref) {
    return relationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RelationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RelationsRepository>(value),
    );
  }
}

String _$relationsRepositoryHash() =>
    r'b591ad6de5811eab26dc2bf8b30e33508f45f8dd';

@ProviderFor(relationsList)
final relationsListProvider = RelationsListFamily._();

final class RelationsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CareRelationResponse>>,
          List<CareRelationResponse>,
          FutureOr<List<CareRelationResponse>>
        >
    with
        $FutureModifier<List<CareRelationResponse>>,
        $FutureProvider<List<CareRelationResponse>> {
  RelationsListProvider._({
    required RelationsListFamily super.from,
    required ({String? hostId, String? caregiverId, bool activeOnly})
    super.argument,
  }) : super(
         retry: null,
         name: r'relationsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$relationsListHash();

  @override
  String toString() {
    return r'relationsListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<CareRelationResponse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CareRelationResponse>> create(Ref ref) {
    final argument =
        this.argument
            as ({String? hostId, String? caregiverId, bool activeOnly});
    return relationsList(
      ref,
      hostId: argument.hostId,
      caregiverId: argument.caregiverId,
      activeOnly: argument.activeOnly,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RelationsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$relationsListHash() => r'3ccc4c6280a7ace326d78e76883518ae3c271ca4';

final class RelationsListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<CareRelationResponse>>,
          ({String? hostId, String? caregiverId, bool activeOnly})
        > {
  RelationsListFamily._()
    : super(
        retry: null,
        name: r'relationsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RelationsListProvider call({
    String? hostId,
    String? caregiverId,
    bool activeOnly = true,
  }) => RelationsListProvider._(
    argument: (
      hostId: hostId,
      caregiverId: caregiverId,
      activeOnly: activeOnly,
    ),
    from: this,
  );

  @override
  String toString() => r'relationsListProvider';
}
