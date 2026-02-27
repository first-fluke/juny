// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedResponseUserResponse _$PaginatedResponseUserResponseFromJson(
  Map<String, dynamic> json,
) => _PaginatedResponseUserResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => UserResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaginatedResponseUserResponseToJson(
  _PaginatedResponseUserResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
