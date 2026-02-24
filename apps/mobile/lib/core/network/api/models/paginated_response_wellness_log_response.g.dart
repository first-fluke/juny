// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response_wellness_log_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedResponseWellnessLogResponse
_$PaginatedResponseWellnessLogResponseFromJson(Map<String, dynamic> json) =>
    _PaginatedResponseWellnessLogResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => WellnessLogResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedResponseWellnessLogResponseToJson(
  _PaginatedResponseWellnessLogResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
