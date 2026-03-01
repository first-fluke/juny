// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response_notification_log_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedResponseNotificationLogResponse
_$PaginatedResponseNotificationLogResponseFromJson(Map<String, dynamic> json) =>
    _PaginatedResponseNotificationLogResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => NotificationLogResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedResponseNotificationLogResponseToJson(
  _PaginatedResponseNotificationLogResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
