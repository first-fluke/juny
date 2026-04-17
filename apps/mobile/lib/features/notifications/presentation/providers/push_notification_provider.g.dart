// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [PushNotificationService] instance.

@ProviderFor(pushNotificationService)
final pushNotificationServiceProvider = PushNotificationServiceProvider._();

/// Provides the singleton [PushNotificationService] instance.

final class PushNotificationServiceProvider
    extends
        $FunctionalProvider<
          PushNotificationService,
          PushNotificationService,
          PushNotificationService
        >
    with $Provider<PushNotificationService> {
  /// Provides the singleton [PushNotificationService] instance.
  PushNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushNotificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushNotificationServiceHash();

  @$internal
  @override
  $ProviderElement<PushNotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushNotificationService create(Ref ref) {
    return pushNotificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushNotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushNotificationService>(value),
    );
  }
}

String _$pushNotificationServiceHash() =>
    r'4730a581cc937f488ee2a274c8d66de537d18103';

/// Manages the full FCM lifecycle: permission, token registration, and
/// token refresh in response to authentication state changes.
///
/// Keep-alive so the subscription persists for the entire app lifetime.

@ProviderFor(PushNotification)
final pushNotificationProvider = PushNotificationProvider._();

/// Manages the full FCM lifecycle: permission, token registration, and
/// token refresh in response to authentication state changes.
///
/// Keep-alive so the subscription persists for the entire app lifetime.
final class PushNotificationProvider
    extends $AsyncNotifierProvider<PushNotification, void> {
  /// Manages the full FCM lifecycle: permission, token registration, and
  /// token refresh in response to authentication state changes.
  ///
  /// Keep-alive so the subscription persists for the entire app lifetime.
  PushNotificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushNotificationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushNotificationHash();

  @$internal
  @override
  PushNotification create() => PushNotification();
}

String _$pushNotificationHash() => r'6f3eadf03c1aad08c7a712a997e8ed67a8dbc92d';

/// Manages the full FCM lifecycle: permission, token registration, and
/// token refresh in response to authentication state changes.
///
/// Keep-alive so the subscription persists for the entire app lifetime.

abstract class _$PushNotification extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
