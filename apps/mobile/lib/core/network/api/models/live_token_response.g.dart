// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LiveTokenResponse _$LiveTokenResponseFromJson(Map<String, dynamic> json) =>
    _LiveTokenResponse(
      token: json['token'] as String,
      roomName: json['room_name'] as String,
      identity: json['identity'] as String,
      role: LiveTokenResponseRole.fromJson(json['role'] as String),
    );

Map<String, dynamic> _$LiveTokenResponseToJson(_LiveTokenResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'room_name': instance.roomName,
      'identity': instance.identity,
      'role': _$LiveTokenResponseRoleEnumMap[instance.role]!,
    };

const _$LiveTokenResponseRoleEnumMap = {
  LiveTokenResponseRole.host: 'host',
  LiveTokenResponseRole.concierge: 'concierge',
  LiveTokenResponseRole.organization: 'organization',
  LiveTokenResponseRole.aiBridge: 'ai-bridge',
  LiveTokenResponseRole.$unknown: r'$unknown',
};
