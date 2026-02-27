// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/fallback_service.dart';
import 'clients/authentication_service.dart';
import 'clients/live_service.dart';
import 'clients/relations_service.dart';
import 'clients/wellness_service.dart';
import 'clients/medications_service.dart';
import 'clients/users_service.dart';
import 'clients/notifications_service.dart';
import 'clients/files_service.dart';
import 'clients/admin_service.dart';

/// juny-api `v0.1.0`
class ApiClient {
  ApiClient(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '0.1.0';

  FallbackService? _fallback;
  AuthenticationService? _authentication;
  LiveService? _live;
  RelationsService? _relations;
  WellnessService? _wellness;
  MedicationsService? _medications;
  UsersService? _users;
  NotificationsService? _notifications;
  FilesService? _files;
  AdminService? _admin;

  FallbackService get fallback => _fallback ??= FallbackService(_dio, baseUrl: _baseUrl);

  AuthenticationService get authentication => _authentication ??= AuthenticationService(_dio, baseUrl: _baseUrl);

  LiveService get live => _live ??= LiveService(_dio, baseUrl: _baseUrl);

  RelationsService get relations => _relations ??= RelationsService(_dio, baseUrl: _baseUrl);

  WellnessService get wellness => _wellness ??= WellnessService(_dio, baseUrl: _baseUrl);

  MedicationsService get medications => _medications ??= MedicationsService(_dio, baseUrl: _baseUrl);

  UsersService get users => _users ??= UsersService(_dio, baseUrl: _baseUrl);

  NotificationsService get notifications => _notifications ??= NotificationsService(_dio, baseUrl: _baseUrl);

  FilesService get files => _files ??= FilesService(_dio, baseUrl: _baseUrl);

  AdminService get admin => _admin ??= AdminService(_dio, baseUrl: _baseUrl);
}
