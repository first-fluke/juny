// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'pagination_meta.dart';
import 'user_response.dart';

part 'paginated_response_user_response.freezed.dart';
part 'paginated_response_user_response.g.dart';

@Freezed()
abstract class PaginatedResponseUserResponse with _$PaginatedResponseUserResponse {
  const factory PaginatedResponseUserResponse({
    required List<UserResponse> data,
    required PaginationMeta meta,
  }) = _PaginatedResponseUserResponse;
  
  factory PaginatedResponseUserResponse.fromJson(Map<String, Object?> json) => _$PaginatedResponseUserResponseFromJson(json);
}
