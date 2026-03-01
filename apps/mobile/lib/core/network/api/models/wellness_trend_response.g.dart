// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_trend_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WellnessTrendResponse _$WellnessTrendResponseFromJson(
  Map<String, dynamic> json,
) => _WellnessTrendResponse(
  hostId: json['host_id'] as String,
  dateFrom: json['date_from'] as String,
  dateTo: json['date_to'] as String,
  dailyStats: (json['daily_stats'] as List<dynamic>)
      .map((e) => DailyWellnessStat.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WellnessTrendResponseToJson(
  _WellnessTrendResponse instance,
) => <String, dynamic>{
  'host_id': instance.hostId,
  'date_from': instance.dateFrom,
  'date_to': instance.dateTo,
  'daily_stats': instance.dailyStats,
};
