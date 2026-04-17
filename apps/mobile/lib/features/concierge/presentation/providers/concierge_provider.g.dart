// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concierge_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(conciergeRepository)
final conciergeRepositoryProvider = ConciergeRepositoryProvider._();

final class ConciergeRepositoryProvider
    extends
        $FunctionalProvider<
          ConciergeRepository,
          ConciergeRepository,
          ConciergeRepository
        >
    with $Provider<ConciergeRepository> {
  ConciergeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conciergeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conciergeRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConciergeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConciergeRepository create(Ref ref) {
    return conciergeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConciergeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConciergeRepository>(value),
    );
  }
}

String _$conciergeRepositoryHash() =>
    r'78bdc12641165b22ac284843d394cebf0ba565cf';

/// Returns aggregated host summaries for the authenticated concierge user.
///
/// Resolves the current user ID first, then fetches all active relations
/// where the current user is the caregiver and aggregates per-host data.

@ProviderFor(conciergeHostSummaries)
final conciergeHostSummariesProvider = ConciergeHostSummariesProvider._();

/// Returns aggregated host summaries for the authenticated concierge user.
///
/// Resolves the current user ID first, then fetches all active relations
/// where the current user is the caregiver and aggregates per-host data.

final class ConciergeHostSummariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HostSummary>>,
          List<HostSummary>,
          FutureOr<List<HostSummary>>
        >
    with
        $FutureModifier<List<HostSummary>>,
        $FutureProvider<List<HostSummary>> {
  /// Returns aggregated host summaries for the authenticated concierge user.
  ///
  /// Resolves the current user ID first, then fetches all active relations
  /// where the current user is the caregiver and aggregates per-host data.
  ConciergeHostSummariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conciergeHostSummariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conciergeHostSummariesHash();

  @$internal
  @override
  $FutureProviderElement<List<HostSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HostSummary>> create(Ref ref) {
    return conciergeHostSummaries(ref);
  }
}

String _$conciergeHostSummariesHash() =>
    r'ec37d4410f56ad20c42280fa37b7d19d9396ac1b';
