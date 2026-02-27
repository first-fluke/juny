// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/device_token_create.dart';
import '../models/device_token_response.dart';

part 'notifications_service.g.dart';

@RestApi()
abstract class NotificationsService {
  factory NotificationsService(Dio dio, {String? baseUrl}) = _NotificationsService;

  /// List Device Tokens.
  ///
  /// List the current user's active device tokens.
  @GET('/api/v1/notifications/device-tokens')
  Future<List<DeviceTokenResponse>> listDeviceTokensApiV1NotificationsDeviceTokensGet();

  /// Register Device Token.
  ///
  /// Register a device token for push notifications.
  @POST('/api/v1/notifications/device-tokens')
  Future<DeviceTokenResponse> registerDeviceTokenApiV1NotificationsDeviceTokensPost({
    @Body() required DeviceTokenCreate body,
  });

  /// Unregister Device Token.
  ///
  /// Deactivate a device token.
  @DELETE('/api/v1/notifications/device-tokens/{token_id}')
  Future<void> unregisterDeviceTokenApiV1NotificationsDeviceTokensTokenIdDelete({
    @Path('token_id') required String tokenId,
  });
}
