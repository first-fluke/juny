// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_meta.freezed.dart';
part 'pagination_meta.g.dart';

/// Pagination metadata.
@Freezed()
abstract class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    /// Current page number
    required int page,

    /// Items per page
    required int limit,

    /// Total number of items
    required int total,

    /// Total number of pages
    @JsonKey(name: 'total_pages') required int totalPages,

    /// Whether there is a next page
    @JsonKey(name: 'has_next') required bool hasNext,

    /// Whether there is a previous page
    @JsonKey(name: 'has_prev') required bool hasPrev,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, Object?> json) =>
      _$PaginationMetaFromJson(json);
}
