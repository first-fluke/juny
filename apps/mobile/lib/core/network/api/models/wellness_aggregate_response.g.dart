// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_aggregate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WellnessAggregateResponse _$WellnessAggregateResponseFromJson(
  Map<String, dynamic> json,
) => _WellnessAggregateResponse(
  hostId: json['host_id'] as String,
  date: json['date'] as String,
  totalLogs: (json['total_logs'] as num).toInt(),
  byStatus: Map<String, int>.from(json['by_status'] as Map),
);

Map<String, dynamic> _$WellnessAggregateResponseToJson(
  _WellnessAggregateResponse instance,
) => <String, dynamic>{
  'host_id': instance.hostId,
  'date': instance.date,
  'total_logs': instance.totalLogs,
  'by_status': instance.byStatus,
};
