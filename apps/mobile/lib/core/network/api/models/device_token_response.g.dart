// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceTokenResponse _$DeviceTokenResponseFromJson(Map<String, dynamic> json) =>
    _DeviceTokenResponse(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      token: json['token'] as String,
      platform: json['platform'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DeviceTokenResponseToJson(
  _DeviceTokenResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'token': instance.token,
  'platform': instance.platform,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
};
