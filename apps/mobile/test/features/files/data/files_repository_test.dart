import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/files/data/files_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockFilesService extends Mock implements FilesService {}

class _FakeFile extends Fake implements File {}

void main() {
  late _MockFilesService mockService;
  late FilesRepository sut;

  setUp(() {
    mockService = _MockFilesService();
    sut = FilesRepository(service: mockService);
    registerFallbackValue(_FakeFile());
  });

  group('FilesRepository', () {
    test('uploadFile delegates to service', () async {
      final file = _FakeFile();
      const expected = FileUploadResponse(
        key: 'uploads/abc',
        url: 'https://example.com/abc',
        contentType: 'image/png',
        size: 1024,
      );
      when(
        () => mockService.uploadFileApiV1FilesUploadPost(
          file: any(named: 'file'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await sut.uploadFile(file);

      expect(result, expected);
      verify(
        () => mockService.uploadFileApiV1FilesUploadPost(file: file),
      ).called(1);
    });

    test('getFile delegates with key', () async {
      when(
        () => mockService.getFileApiV1FilesKeyGet(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      await sut.getFile('uploads/abc');

      verify(
        () => mockService.getFileApiV1FilesKeyGet(key: 'uploads/abc'),
      ).called(1);
    });

    test('deleteFile delegates with key', () async {
      when(
        () => mockService.deleteFileApiV1FilesKeyDelete(
          key: any(named: 'key'),
        ),
      ).thenAnswer((_) async {});

      await sut.deleteFile('uploads/abc');

      verify(
        () => mockService.deleteFileApiV1FilesKeyDelete(key: 'uploads/abc'),
      ).called(1);
    });
  });
}
