// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(usersRepository)
final usersRepositoryProvider = UsersRepositoryProvider._();

final class UsersRepositoryProvider
    extends
        $FunctionalProvider<UsersRepository, UsersRepository, UsersRepository>
    with $Provider<UsersRepository> {
  UsersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usersRepositoryHash();

  @$internal
  @override
  $ProviderElement<UsersRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UsersRepository create(Ref ref) {
    return usersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UsersRepository>(value),
    );
  }
}

String _$usersRepositoryHash() => r'7a1abf8e7fc2ca579eea68697f08e909062f0c75';

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserResponse>,
          UserResponse,
          FutureOr<UserResponse>
        >
    with $FutureModifier<UserResponse>, $FutureProvider<UserResponse> {
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $FutureProviderElement<UserResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserResponse> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'feb04eb3beb2e58aafec3169fa209cddd7a1b6f2';
