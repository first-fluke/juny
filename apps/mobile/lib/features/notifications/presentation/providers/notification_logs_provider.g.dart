// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_logs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationLogsRepository)
final notificationLogsRepositoryProvider =
    NotificationLogsRepositoryProvider._();

final class NotificationLogsRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationLogsRepository,
          NotificationLogsRepository,
          NotificationLogsRepository
        >
    with $Provider<NotificationLogsRepository> {
  NotificationLogsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationLogsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationLogsRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationLogsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationLogsRepository create(Ref ref) {
    return notificationLogsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationLogsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationLogsRepository>(value),
    );
  }
}

String _$notificationLogsRepositoryHash() =>
    r'5b072882c61af2f2f0f8c272630a810f92409a66';

/// Provides a paginated page of notification logs.
///
/// [page] is 1-based. Re-watch with a different [page] value to fetch
/// subsequent pages.

@ProviderFor(notificationLogs)
final notificationLogsProvider = NotificationLogsFamily._();

/// Provides a paginated page of notification logs.
///
/// [page] is 1-based. Re-watch with a different [page] value to fetch
/// subsequent pages.

final class NotificationLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedResponseNotificationLogResponse>,
          PaginatedResponseNotificationLogResponse,
          FutureOr<PaginatedResponseNotificationLogResponse>
        >
    with
        $FutureModifier<PaginatedResponseNotificationLogResponse>,
        $FutureProvider<PaginatedResponseNotificationLogResponse> {
  /// Provides a paginated page of notification logs.
  ///
  /// [page] is 1-based. Re-watch with a different [page] value to fetch
  /// subsequent pages.
  NotificationLogsProvider._({
    required NotificationLogsFamily super.from,
    required ({int page, int limit}) super.argument,
  }) : super(
         retry: null,
         name: r'notificationLogsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$notificationLogsHash();

  @override
  String toString() {
    return r'notificationLogsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PaginatedResponseNotificationLogResponse>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedResponseNotificationLogResponse> create(Ref ref) {
    final argument = this.argument as ({int page, int limit});
    return notificationLogs(ref, page: argument.page, limit: argument.limit);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationLogsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notificationLogsHash() => r'91847451f4a489950128894279d782c67c8bf1e0';

/// Provides a paginated page of notification logs.
///
/// [page] is 1-based. Re-watch with a different [page] value to fetch
/// subsequent pages.

final class NotificationLogsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PaginatedResponseNotificationLogResponse>,
          ({int page, int limit})
        > {
  NotificationLogsFamily._()
    : super(
        retry: null,
        name: r'notificationLogsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides a paginated page of notification logs.
  ///
  /// [page] is 1-based. Re-watch with a different [page] value to fetch
  /// subsequent pages.

  NotificationLogsProvider call({int page = 1, int limit = 20}) =>
      NotificationLogsProvider._(
        argument: (page: page, limit: limit),
        from: this,
      );

  @override
  String toString() => r'notificationLogsProvider';
}
