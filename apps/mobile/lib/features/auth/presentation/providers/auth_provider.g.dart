// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Auth)
final authProvider = AuthProvider._();

final class AuthProvider extends $NotifierProvider<Auth, AuthState> {
  AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authHash() => r'6edb8a401e7459c1050617ff429ceee5fbfdc2bd';

abstract class _$Auth extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(apiClientWrapper)
final apiClientWrapperProvider = ApiClientWrapperProvider._();

final class ApiClientWrapperProvider
    extends
        $FunctionalProvider<
          ApiClientWrapper,
          ApiClientWrapper,
          ApiClientWrapper
        >
    with $Provider<ApiClientWrapper> {
  ApiClientWrapperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientWrapperProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientWrapperHash();

  @$internal
  @override
  $ProviderElement<ApiClientWrapper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClientWrapper create(Ref ref) {
    return apiClientWrapper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClientWrapper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClientWrapper>(value),
    );
  }
}

String _$apiClientWrapperHash() => r'd03443f090d76535f0246f843ff4b9c0496f41b4';
