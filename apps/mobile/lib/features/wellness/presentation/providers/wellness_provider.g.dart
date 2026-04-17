// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wellnessRepository)
final wellnessRepositoryProvider = WellnessRepositoryProvider._();

final class WellnessRepositoryProvider
    extends
        $FunctionalProvider<
          WellnessRepository,
          WellnessRepository,
          WellnessRepository
        >
    with $Provider<WellnessRepository> {
  WellnessRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wellnessRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wellnessRepositoryHash();

  @$internal
  @override
  $ProviderElement<WellnessRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WellnessRepository create(Ref ref) {
    return wellnessRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WellnessRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WellnessRepository>(value),
    );
  }
}

String _$wellnessRepositoryHash() =>
    r'b46e592cb8b53a625ff35c3feaeda5f3d88d87c6';

@ProviderFor(wellnessLogsList)
final wellnessLogsListProvider = WellnessLogsListFamily._();

final class WellnessLogsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedResponseWellnessLogResponse>,
          PaginatedResponseWellnessLogResponse,
          FutureOr<PaginatedResponseWellnessLogResponse>
        >
    with
        $FutureModifier<PaginatedResponseWellnessLogResponse>,
        $FutureProvider<PaginatedResponseWellnessLogResponse> {
  WellnessLogsListProvider._({
    required WellnessLogsListFamily super.from,
    required ({String hostId, int page}) super.argument,
  }) : super(
         retry: null,
         name: r'wellnessLogsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$wellnessLogsListHash();

  @override
  String toString() {
    return r'wellnessLogsListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PaginatedResponseWellnessLogResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedResponseWellnessLogResponse> create(Ref ref) {
    final argument = this.argument as ({String hostId, int page});
    return wellnessLogsList(ref, hostId: argument.hostId, page: argument.page);
  }

  @override
  bool operator ==(Object other) {
    return other is WellnessLogsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wellnessLogsListHash() => r'ff62483e6c8efe9a893828c446813d3dd37f5c34';

final class WellnessLogsListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PaginatedResponseWellnessLogResponse>,
          ({String hostId, int page})
        > {
  WellnessLogsListFamily._()
    : super(
        retry: null,
        name: r'wellnessLogsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WellnessLogsListProvider call({required String hostId, int page = 1}) =>
      WellnessLogsListProvider._(
        argument: (hostId: hostId, page: page),
        from: this,
      );

  @override
  String toString() => r'wellnessLogsListProvider';
}

/// Fetches wellness trend data for the past 30 days.

@ProviderFor(wellnessTrends)
final wellnessTrendsProvider = WellnessTrendsFamily._();

/// Fetches wellness trend data for the past 30 days.

final class WellnessTrendsProvider
    extends
        $FunctionalProvider<
          AsyncValue<WellnessTrendResponse>,
          WellnessTrendResponse,
          FutureOr<WellnessTrendResponse>
        >
    with
        $FutureModifier<WellnessTrendResponse>,
        $FutureProvider<WellnessTrendResponse> {
  /// Fetches wellness trend data for the past 30 days.
  WellnessTrendsProvider._({
    required WellnessTrendsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'wellnessTrendsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$wellnessTrendsHash();

  @override
  String toString() {
    return r'wellnessTrendsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WellnessTrendResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WellnessTrendResponse> create(Ref ref) {
    final argument = this.argument as String;
    return wellnessTrends(ref, hostId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WellnessTrendsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wellnessTrendsHash() => r'486869311acdc244cc9b4386f09bdfed967548be';

/// Fetches wellness trend data for the past 30 days.

final class WellnessTrendsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WellnessTrendResponse>, String> {
  WellnessTrendsFamily._()
    : super(
        retry: null,
        name: r'wellnessTrendsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches wellness trend data for the past 30 days.

  WellnessTrendsProvider call({required String hostId}) =>
      WellnessTrendsProvider._(argument: hostId, from: this);

  @override
  String toString() => r'wellnessTrendsProvider';
}
