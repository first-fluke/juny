// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationsRepository)
final notificationsRepositoryProvider = NotificationsRepositoryProvider._();

final class NotificationsRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationsRepository,
          NotificationsRepository,
          NotificationsRepository
        >
    with $Provider<NotificationsRepository> {
  NotificationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationsRepository create(Ref ref) {
    return notificationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationsRepository>(value),
    );
  }
}

String _$notificationsRepositoryHash() =>
    r'618cb0b06e6e4b0e6ab36f473edd4d9eb6cd422f';

@ProviderFor(notificationPreferences)
final notificationPreferencesProvider = NotificationPreferencesProvider._();

final class NotificationPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificationPreferenceResponse>,
          NotificationPreferenceResponse,
          FutureOr<NotificationPreferenceResponse>
        >
    with
        $FutureModifier<NotificationPreferenceResponse>,
        $FutureProvider<NotificationPreferenceResponse> {
  NotificationPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<NotificationPreferenceResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NotificationPreferenceResponse> create(Ref ref) {
    return notificationPreferences(ref);
  }
}

String _$notificationPreferencesHash() =>
    r'a4f946419cb5e221810e67d647cc50a8f046ee00';

@ProviderFor(notificationLogsList)
final notificationLogsListProvider = NotificationLogsListFamily._();

final class NotificationLogsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedResponseNotificationLogResponse>,
          PaginatedResponseNotificationLogResponse,
          FutureOr<PaginatedResponseNotificationLogResponse>
        >
    with
        $FutureModifier<PaginatedResponseNotificationLogResponse>,
        $FutureProvider<PaginatedResponseNotificationLogResponse> {
  NotificationLogsListProvider._({
    required NotificationLogsListFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'notificationLogsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$notificationLogsListHash();

  @override
  String toString() {
    return r'notificationLogsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PaginatedResponseNotificationLogResponse>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedResponseNotificationLogResponse> create(Ref ref) {
    final argument = this.argument as int;
    return notificationLogsList(ref, page: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationLogsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notificationLogsListHash() =>
    r'88edb3600166eb320abdaff0aaf8df9ce44cb451';

final class NotificationLogsListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PaginatedResponseNotificationLogResponse>,
          int
        > {
  NotificationLogsListFamily._()
    : super(
        retry: null,
        name: r'notificationLogsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NotificationLogsListProvider call({int page = 1}) =>
      NotificationLogsListProvider._(argument: page, from: this);

  @override
  String toString() => r'notificationLogsListProvider';
}
