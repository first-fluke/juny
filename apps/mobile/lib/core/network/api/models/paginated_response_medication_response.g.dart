// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response_medication_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedResponseMedicationResponse
_$PaginatedResponseMedicationResponseFromJson(Map<String, dynamic> json) =>
    _PaginatedResponseMedicationResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => MedicationResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedResponseMedicationResponseToJson(
  _PaginatedResponseMedicationResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
