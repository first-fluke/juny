// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceTokenCreate _$DeviceTokenCreateFromJson(Map<String, dynamic> json) =>
    _DeviceTokenCreate(
      token: json['token'] as String,
      platform: DeviceTokenCreatePlatform.fromJson(json['platform'] as String),
    );

Map<String, dynamic> _$DeviceTokenCreateToJson(_DeviceTokenCreate instance) =>
    <String, dynamic>{
      'token': instance.token,
      'platform': _$DeviceTokenCreatePlatformEnumMap[instance.platform]!,
    };

const _$DeviceTokenCreatePlatformEnumMap = {
  DeviceTokenCreatePlatform.ios: 'ios',
  DeviceTokenCreatePlatform.android: 'android',
  DeviceTokenCreatePlatform.web: 'web',
  DeviceTokenCreatePlatform.$unknown: r'$unknown',
};
