// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OAuthLoginRequest _$OAuthLoginRequestFromJson(Map<String, dynamic> json) =>
    _OAuthLoginRequest(
      provider: OAuthLoginRequestProvider.fromJson(json['provider'] as String),
      accessToken: json['access_token'] as String,
    );

Map<String, dynamic> _$OAuthLoginRequestToJson(_OAuthLoginRequest instance) =>
    <String, dynamic>{
      'provider': _$OAuthLoginRequestProviderEnumMap[instance.provider]!,
      'access_token': instance.accessToken,
    };

const _$OAuthLoginRequestProviderEnumMap = {
  OAuthLoginRequestProvider.google: 'google',
  OAuthLoginRequestProvider.github: 'github',
  OAuthLoginRequestProvider.facebook: 'facebook',
  OAuthLoginRequestProvider.$unknown: r'$unknown',
};
