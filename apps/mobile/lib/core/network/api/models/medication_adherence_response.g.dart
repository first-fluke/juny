// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_adherence_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicationAdherenceResponse _$MedicationAdherenceResponseFromJson(
  Map<String, dynamic> json,
) => _MedicationAdherenceResponse(
  hostId: json['host_id'] as String,
  dateFrom: json['date_from'] as String,
  dateTo: json['date_to'] as String,
  total: (json['total'] as num).toInt(),
  taken: (json['taken'] as num).toInt(),
  missed: (json['missed'] as num).toInt(),
  adherenceRate: json['adherence_rate'] as num,
);

Map<String, dynamic> _$MedicationAdherenceResponseToJson(
  _MedicationAdherenceResponse instance,
) => <String, dynamic>{
  'host_id': instance.hostId,
  'date_from': instance.dateFrom,
  'date_to': instance.dateTo,
  'total': instance.total,
  'taken': instance.taken,
  'missed': instance.missed,
  'adherence_rate': instance.adherenceRate,
};
