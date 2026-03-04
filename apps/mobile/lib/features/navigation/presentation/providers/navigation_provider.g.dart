// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(navigationRepository)
final navigationRepositoryProvider = NavigationRepositoryProvider._();

final class NavigationRepositoryProvider
    extends
        $FunctionalProvider<
          NavigationRepository,
          NavigationRepository,
          NavigationRepository
        >
    with $Provider<NavigationRepository> {
  NavigationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navigationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navigationRepositoryHash();

  @$internal
  @override
  $ProviderElement<NavigationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NavigationRepository create(Ref ref) {
    return navigationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NavigationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NavigationRepository>(value),
    );
  }
}

String _$navigationRepositoryHash() =>
    r'87fbf4b5c29932c7899ad285ec1f5a3c03a3569c';

@ProviderFor(activeNavigationSession)
final activeNavigationSessionProvider = ActiveNavigationSessionFamily._();

final class ActiveNavigationSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<NavigationSessionResponse>,
          NavigationSessionResponse,
          FutureOr<NavigationSessionResponse>
        >
    with
        $FutureModifier<NavigationSessionResponse>,
        $FutureProvider<NavigationSessionResponse> {
  ActiveNavigationSessionProvider._({
    required ActiveNavigationSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activeNavigationSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeNavigationSessionHash();

  @override
  String toString() {
    return r'activeNavigationSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<NavigationSessionResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NavigationSessionResponse> create(Ref ref) {
    final argument = this.argument as String;
    return activeNavigationSession(ref, hostId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveNavigationSessionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeNavigationSessionHash() =>
    r'19cc130c45f162db829f1cd26754c3d3260ecac1';

final class ActiveNavigationSessionFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<NavigationSessionResponse>, String> {
  ActiveNavigationSessionFamily._()
    : super(
        retry: null,
        name: r'activeNavigationSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActiveNavigationSessionProvider call({required String hostId}) =>
      ActiveNavigationSessionProvider._(argument: hostId, from: this);

  @override
  String toString() => r'activeNavigationSessionProvider';
}

@ProviderFor(hostLocation)
final hostLocationProvider = HostLocationFamily._();

final class HostLocationProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocationWaypointResponse?>,
          LocationWaypointResponse?,
          FutureOr<LocationWaypointResponse?>
        >
    with
        $FutureModifier<LocationWaypointResponse?>,
        $FutureProvider<LocationWaypointResponse?> {
  HostLocationProvider._({
    required HostLocationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hostLocationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hostLocationHash();

  @override
  String toString() {
    return r'hostLocationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LocationWaypointResponse?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocationWaypointResponse?> create(Ref ref) {
    final argument = this.argument as String;
    return hostLocation(ref, hostId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HostLocationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hostLocationHash() => r'490b1c7da2b7e50cca859350ac0dcc4f7a8535f0';

final class HostLocationFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<LocationWaypointResponse?>, String> {
  HostLocationFamily._()
    : super(
        retry: null,
        name: r'hostLocationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HostLocationProvider call({required String hostId}) =>
      HostLocationProvider._(argument: hostId, from: this);

  @override
  String toString() => r'hostLocationProvider';
}
