// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_log_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationLogResponse _$NotificationLogResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationLogResponse(
  id: json['id'] as String,
  recipientId: json['recipient_id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  status: json['status'] as String,
  channel: json['channel'] as String,
  metadata: json['metadata'],
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$NotificationLogResponseToJson(
  _NotificationLogResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'recipient_id': instance.recipientId,
  'title': instance.title,
  'body': instance.body,
  'status': instance.status,
  'channel': instance.channel,
  'metadata': instance.metadata,
  'created_at': instance.createdAt.toIso8601String(),
};
