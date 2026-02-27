// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_upload_response.freezed.dart';
part 'file_upload_response.g.dart';

/// Response after a successful file upload.
@Freezed()
abstract class FileUploadResponse with _$FileUploadResponse {
  const factory FileUploadResponse({
    required String key,
    required String url,
    @JsonKey(name: 'content_type')
    required String contentType,
    required int size,
  }) = _FileUploadResponse;
  
  factory FileUploadResponse.fromJson(Map<String, Object?> json) => _$FileUploadResponseFromJson(json);
}
