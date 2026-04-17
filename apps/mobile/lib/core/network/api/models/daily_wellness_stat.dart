// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_wellness_stat.freezed.dart';
part 'daily_wellness_stat.g.dart';

/// Daily aggregated wellness statistics.
@Freezed()
abstract class DailyWellnessStat with _$DailyWellnessStat {
  const factory DailyWellnessStat({
    required String date,
    @Default(0) int normal,
    @Default(0) int warning,
    @Default(0) int emergency,
  }) = _DailyWellnessStat;

  factory DailyWellnessStat.fromJson(Map<String, Object?> json) =>
      _$DailyWellnessStatFromJson(json);
}
