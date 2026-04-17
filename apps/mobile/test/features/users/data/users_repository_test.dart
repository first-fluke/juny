import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/users/data/users_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockUsersService extends Mock implements UsersService {}

class _MockFilesService extends Mock implements FilesService {}

class _FakeFile extends Fake implements File {}

UserResponse _user({String name = 'Alice', String? image}) => UserResponse(
  id: 'user-001',
  email: 'alice@example.com',
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  late _MockUsersService mockUsers;
  late _MockFilesService mockFiles;
  late UsersRepository sut;

  setUp(() {
    mockUsers = _MockUsersService();
    mockFiles = _MockFilesService();
    sut = UsersRepository(service: mockUsers, filesService: mockFiles);
    registerFallbackValue(const UserUpdate());
    registerFallbackValue(_FakeFile());
  });

  group('UsersRepository', () {
    test('getMe delegates to users service', () async {
      final expected = _user();
      when(
        () => mockUsers.getMyProfileApiV1UsersMeGet(),
      ).thenAnswer((_) async => expected);

      final result = await sut.getMe();

      expect(result, expected);
    });

    test('updateMe posts UserUpdate payload', () async {
      when(
        () => mockUsers.updateMyProfileApiV1UsersMePatch(
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => _user(name: 'Bob'));

      await sut.updateMe(name: 'Bob', image: 'https://cdn/img.png');

      final captured =
          verify(
                () => mockUsers.updateMyProfileApiV1UsersMePatch(
                  body: captureAny(named: 'body'),
                ),
              ).captured.single
              as UserUpdate;
      expect(captured.name, 'Bob');
      expect(captured.image, 'https://cdn/img.png');
    });

    test('deleteMe delegates to users service', () async {
      when(
        () => mockUsers.deleteMeApiV1UsersMeDelete(),
      ).thenAnswer((_) async {});

      await sut.deleteMe();

      verify(() => mockUsers.deleteMeApiV1UsersMeDelete()).called(1);
    });

    test('getUser delegates with user id', () async {
      when(
        () => mockUsers.getUserApiV1UsersUserIdGet(
          userId: any(named: 'userId'),
        ),
      ).thenAnswer((_) async => _user());

      await sut.getUser('user-001');

      verify(
        () => mockUsers.getUserApiV1UsersUserIdGet(userId: 'user-001'),
      ).called(1);
    });

    test(
      'uploadPhoto uploads file then updates profile with image URL',
      () async {
        final file = _FakeFile();
        const upload = FileUploadResponse(
          key: 'uploads/photo',
          url: 'https://cdn/photo.png',
          contentType: 'image/png',
          size: 2048,
        );
        when(
          () => mockFiles.uploadFileApiV1FilesUploadPost(
            file: any(named: 'file'),
          ),
        ).thenAnswer((_) async => upload);
        when(
          () => mockUsers.updateMyProfileApiV1UsersMePatch(
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => _user(image: upload.url));

        final result = await sut.uploadPhoto(file);

        expect(result, isA<UserResponse>());
        final captured =
            verify(
                  () => mockUsers.updateMyProfileApiV1UsersMePatch(
                    body: captureAny(named: 'body'),
                  ),
                ).captured.single
                as UserUpdate;
        expect(captured.image, upload.url);
        expect(captured.name, isNull);
      },
    );
  });
}
