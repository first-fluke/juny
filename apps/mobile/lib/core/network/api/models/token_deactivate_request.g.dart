// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_deactivate_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenDeactivateRequest _$TokenDeactivateRequestFromJson(
  Map<String, dynamic> json,
) => _TokenDeactivateRequest(
  tokens: (json['tokens'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$TokenDeactivateRequestToJson(
  _TokenDeactivateRequest instance,
) => <String, dynamic>{'tokens': instance.tokens};
