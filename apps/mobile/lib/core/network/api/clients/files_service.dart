// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/file_upload_response.dart';

part 'files_service.g.dart';

@RestApi()
abstract class FilesService {
  factory FilesService(Dio dio, {String? baseUrl}) = _FilesService;

  /// Upload File.
  ///
  /// Upload a file (max 10 MB).
  @MultiPart()
  @POST('/api/v1/files/upload')
  Future<FileUploadResponse> uploadFileApiV1FilesUploadPost({
    @Part(name: 'file') required File file,
  });

  /// Get File.
  ///
  /// Redirect to a signed URL for the requested file.
  @GET('/api/v1/files/{key}')
  Future<void> getFileApiV1FilesKeyGet({
    @Path('key') required String key,
  });

  /// Delete File.
  ///
  /// Delete a file from storage.
  @DELETE('/api/v1/files/{key}')
  Future<void> deleteFileApiV1FilesKeyDelete({
    @Path('key') required String key,
  });
}
