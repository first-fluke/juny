// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'daily_wellness_stat.dart';

part 'wellness_trend_response.freezed.dart';
part 'wellness_trend_response.g.dart';

/// Response model for wellness trend analysis.
@Freezed()
abstract class WellnessTrendResponse with _$WellnessTrendResponse {
  const factory WellnessTrendResponse({
    @JsonKey(name: 'host_id') required String hostId,
    @JsonKey(name: 'date_from') required String dateFrom,
    @JsonKey(name: 'date_to') required String dateTo,
    @JsonKey(name: 'daily_stats') required List<DailyWellnessStat> dailyStats,
  }) = _WellnessTrendResponse;

  factory WellnessTrendResponse.fromJson(Map<String, Object?> json) =>
      _$WellnessTrendResponseFromJson(json);
}
