import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/data/secure_token_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('SecureTokenStorage', () {
    late _MockFlutterSecureStorage mockStorage;
    late SecureTokenStorage sut;

    setUp(() {
      mockStorage = _MockFlutterSecureStorage();
      sut = SecureTokenStorage(storage: mockStorage);
    });

    group('readAccessToken', () {
      test('returns value from storage', () async {
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => 'access_abc');

        final result = await sut.readAccessToken();

        expect(result, 'access_abc');
        verify(() => mockStorage.read(key: 'access_token')).called(1);
      });

      test('returns null when not stored', () async {
        when(
          () => mockStorage.read(key: 'access_token'),
        ).thenAnswer((_) async => null);

        final result = await sut.readAccessToken();

        expect(result, isNull);
      });
    });

    group('readRefreshToken', () {
      test('returns value from storage', () async {
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => 'refresh_xyz');

        final result = await sut.readRefreshToken();

        expect(result, 'refresh_xyz');
      });

      test('returns null when not stored', () async {
        when(
          () => mockStorage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => null);

        final result = await sut.readRefreshToken();

        expect(result, isNull);
      });
    });

    group('readUserRole', () {
      test('returns value from storage', () async {
        when(
          () => mockStorage.read(key: 'user_role'),
        ).thenAnswer((_) async => 'host');

        final result = await sut.readUserRole();

        expect(result, 'host');
      });

      test('returns null when not stored', () async {
        when(
          () => mockStorage.read(key: 'user_role'),
        ).thenAnswer((_) async => null);

        final result = await sut.readUserRole();

        expect(result, isNull);
      });
    });

    group('writeTokens', () {
      test('writes all three keys to storage', () async {
        when(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await sut.writeTokens(
          accessToken: 'access_abc',
          refreshToken: 'refresh_xyz',
          userRole: 'host',
        );

        verify(
          () => mockStorage.write(key: 'access_token', value: 'access_abc'),
        ).called(1);
        verify(
          () => mockStorage.write(key: 'refresh_token', value: 'refresh_xyz'),
        ).called(1);
        verify(
          () => mockStorage.write(key: 'user_role', value: 'host'),
        ).called(1);
      });
    });

    group('deleteAll', () {
      test('deletes all three keys from storage', () async {
        when(
          () => mockStorage.delete(key: any(named: 'key')),
        ).thenAnswer((_) async {});

        await sut.deleteAll();

        verify(() => mockStorage.delete(key: 'access_token')).called(1);
        verify(() => mockStorage.delete(key: 'refresh_token')).called(1);
        verify(() => mockStorage.delete(key: 'user_role')).called(1);
      });
    });
  });
}
