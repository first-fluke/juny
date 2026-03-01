// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_wellness_stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyWellnessStat _$DailyWellnessStatFromJson(Map<String, dynamic> json) =>
    _DailyWellnessStat(
      date: json['date'] as String,
      normal: (json['normal'] as num?)?.toInt() ?? 0,
      warning: (json['warning'] as num?)?.toInt() ?? 0,
      emergency: (json['emergency'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DailyWellnessStatToJson(_DailyWellnessStat instance) =>
    <String, dynamic>{
      'date': instance.date,
      'normal': instance.normal,
      'warning': instance.warning,
      'emergency': instance.emergency,
    };
