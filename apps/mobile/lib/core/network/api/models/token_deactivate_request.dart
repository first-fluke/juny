// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_deactivate_request.freezed.dart';
part 'token_deactivate_request.g.dart';

@Freezed()
abstract class TokenDeactivateRequest with _$TokenDeactivateRequest {
  const factory TokenDeactivateRequest({
    required List<String> tokens,
  }) = _TokenDeactivateRequest;
  
  factory TokenDeactivateRequest.fromJson(Map<String, Object?> json) => _$TokenDeactivateRequestFromJson(json);
}
