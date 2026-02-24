// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(liveRepository)
final liveRepositoryProvider = LiveRepositoryProvider._();

final class LiveRepositoryProvider
    extends $FunctionalProvider<LiveRepository, LiveRepository, LiveRepository>
    with $Provider<LiveRepository> {
  LiveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveRepositoryHash();

  @$internal
  @override
  $ProviderElement<LiveRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LiveRepository create(Ref ref) {
    return liveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveRepository>(value),
    );
  }
}

String _$liveRepositoryHash() => r'4b137eb8a5b810c009bac1543ed5b996f555cfa5';

@ProviderFor(liveToken)
final liveTokenProvider = LiveTokenFamily._();

final class LiveTokenProvider
    extends
        $FunctionalProvider<
          AsyncValue<LiveTokenResponse>,
          LiveTokenResponse,
          FutureOr<LiveTokenResponse>
        >
    with
        $FutureModifier<LiveTokenResponse>,
        $FutureProvider<LiveTokenResponse> {
  LiveTokenProvider._({
    required LiveTokenFamily super.from,
    required ({String roomName, Role role}) super.argument,
  }) : super(
         retry: null,
         name: r'liveTokenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$liveTokenHash();

  @override
  String toString() {
    return r'liveTokenProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<LiveTokenResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LiveTokenResponse> create(Ref ref) {
    final argument = this.argument as ({String roomName, Role role});
    return liveToken(ref, roomName: argument.roomName, role: argument.role);
  }

  @override
  bool operator ==(Object other) {
    return other is LiveTokenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$liveTokenHash() => r'8a3084b48c0dde6869fd2dfe9b61b678f9799c81';

final class LiveTokenFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<LiveTokenResponse>,
          ({String roomName, Role role})
        > {
  LiveTokenFamily._()
    : super(
        retry: null,
        name: r'liveTokenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LiveTokenProvider call({required String roomName, required Role role}) =>
      LiveTokenProvider._(
        argument: (roomName: roomName, role: role),
        from: this,
      );

  @override
  String toString() => r'liveTokenProvider';
}
