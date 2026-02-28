// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response_care_relation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedResponseCareRelationResponse
_$PaginatedResponseCareRelationResponseFromJson(Map<String, dynamic> json) =>
    _PaginatedResponseCareRelationResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => CareRelationResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedResponseCareRelationResponseToJson(
  _PaginatedResponseCareRelationResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
