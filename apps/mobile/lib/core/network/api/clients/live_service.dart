// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/live_token_response.dart';
import '../models/role.dart';

part 'live_service.g.dart';

@RestApi()
abstract class LiveService {
  factory LiveService(Dio dio, {String? baseUrl}) = _LiveService;

  /// Get Live Token.
  ///
  /// Generate a LiveKit access token for the authenticated user.
  @GET('/api/v1/live/token')
  Future<LiveTokenResponse> getLiveTokenApiV1LiveTokenGet({
    @Query('room_name') required String roomName,
    @Query('role') required Role role,
  });
}
