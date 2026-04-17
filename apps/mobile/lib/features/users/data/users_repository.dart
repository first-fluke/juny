import 'dart:io';

import 'package:mobile/core/network/api/export.dart';

/// {@template users_repository}
/// Data layer for user profile operations.
/// {@endtemplate}
class UsersRepository {
  /// {@macro users_repository}
  UsersRepository({
    required UsersService service,
    required FilesService filesService,
  }) : _service = service,
       _filesService = filesService;

  final UsersService _service;
  final FilesService _filesService;

  Future<UserResponse> getMe() => _service.getMyProfileApiV1UsersMeGet();

  Future<UserResponse> updateMe({String? name, String? image}) =>
      _service.updateMyProfileApiV1UsersMePatch(
        body: UserUpdate(name: name, image: image),
      );

  Future<void> deleteMe() => _service.deleteMeApiV1UsersMeDelete();

  Future<dynamic> exportMyData() =>
      _service.exportMyDataApiV1UsersMeExportGet();

  Future<UserResponse> getUser(String userId) =>
      _service.getUserApiV1UsersUserIdGet(userId: userId);

  /// Uploads [imageFile] to storage and updates the user's profile photo.
  Future<UserResponse> uploadPhoto(File imageFile) async {
    final upload = await _filesService.uploadFileApiV1FilesUploadPost(
      file: imageFile,
    );
    return updateMe(image: upload.url);
  }
}
