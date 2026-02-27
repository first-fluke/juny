// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/paginated_response_user_response.dart';
import '../models/user_response.dart';
import '../models/user_role_update.dart';
import '../models/user_update.dart';

part 'users_service.g.dart';

@RestApi()
abstract class UsersService {
  factory UsersService(Dio dio, {String? baseUrl}) = _UsersService;

  /// Get My Profile.
  ///
  /// Get the current user's profile.
  @GET('/api/v1/users/me')
  Future<UserResponse> getMyProfileApiV1UsersMeGet();

  /// Update My Profile.
  ///
  /// Update the current user's profile (name, image).
  @PATCH('/api/v1/users/me')
  Future<UserResponse> updateMyProfileApiV1UsersMePatch({
    @Body() required UserUpdate body,
  });

  /// List Users.
  ///
  /// List all users (ORGANIZATION role only).
  @GET('/api/v1/users')
  Future<PaginatedResponseUserResponse> listUsersApiV1UsersGet({
    @Query('page') int? page = 1,
    @Query('limit') int? limit = 20,
  });

  /// Get User.
  ///
  /// Get a user by ID.
  ///
  /// Access: self, active CareRelation, or ORGANIZATION.
  @GET('/api/v1/users/{user_id}')
  Future<UserResponse> getUserApiV1UsersUserIdGet({
    @Path('user_id') required String userId,
  });

  /// Delete User.
  ///
  /// Delete a user (ORGANIZATION only).
  @DELETE('/api/v1/users/{user_id}')
  Future<void> deleteUserApiV1UsersUserIdDelete({
    @Path('user_id') required String userId,
  });

  /// Update User Role.
  ///
  /// Change a user's role (ORGANIZATION only).
  @PATCH('/api/v1/users/{user_id}/role')
  Future<UserResponse> updateUserRoleApiV1UsersUserIdRolePatch({
    @Path('user_id') required String userId,
    @Body() required UserRoleUpdate body,
  });
}
