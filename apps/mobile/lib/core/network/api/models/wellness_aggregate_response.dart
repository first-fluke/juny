// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wellness_aggregate_response.freezed.dart';
part 'wellness_aggregate_response.g.dart';

@Freezed()
abstract class WellnessAggregateResponse with _$WellnessAggregateResponse {
  const factory WellnessAggregateResponse({
    @JsonKey(name: 'host_id')
    required String hostId,
    required String date,
    @JsonKey(name: 'total_logs')
    required int totalLogs,
    @JsonKey(name: 'by_status')
    required Map<String, int> byStatus,
  }) = _WellnessAggregateResponse;
  
  factory WellnessAggregateResponse.fromJson(Map<String, Object?> json) => _$WellnessAggregateResponseFromJson(json);
}
