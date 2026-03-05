import 'dart:io';
import 'package:mobile/core/network/api/export.dart';

/// {@template files_repository}
/// Data layer for file operations.
/// {@endtemplate}
class FilesRepository {
  /// {@macro files_repository}
  FilesRepository({required FilesService service}) : _service = service;

  final FilesService _service;

  Future<FileUploadResponse> uploadFile(File file) =>
      _service.uploadFileApiV1FilesUploadPost(file: file);

  Future<void> getFile(String key) =>
      _service.getFileApiV1FilesKeyGet(key: key);

  Future<void> deleteFile(String key) =>
      _service.deleteFileApiV1FilesKeyDelete(key: key);
}
