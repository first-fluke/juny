import 'package:mobile/core/network/api/export.dart';

/// {@template users_repository}
/// Data layer for user profile operations.
/// {@endtemplate}
class UsersRepository {
  /// {@macro users_repository}
  UsersRepository({required UsersService service}) : _service = service;

  final UsersService _service;

  Future<UserResponse> getMe() =>
      _service.getMyProfileApiV1UsersMeGet();

  Future<UserResponse> updateMe({String? name, String? image}) =>
      _service.updateMyProfileApiV1UsersMePatch(
        body: UserUpdate(name: name, image: image),
      );

  Future<void> deleteMe() =>
      _service.deleteMeApiV1UsersMeDelete();

  Future<dynamic> exportMyData() =>
      _service.exportMyDataApiV1UsersMeExportGet();

  Future<UserResponse> getUser(String userId) =>
      _service.getUserApiV1UsersUserIdGet(userId: userId);
}
