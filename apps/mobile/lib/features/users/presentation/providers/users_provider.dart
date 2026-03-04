import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/users/data/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_provider.g.dart';

@riverpod
UsersRepository usersRepository(Ref ref) {
  final apiClient = ref.watch(apiClientWrapperProvider);
  return UsersRepository(service: UsersService(apiClient.dio));
}

@riverpod
Future<UserResponse> currentUser(Ref ref) {
  final repository = ref.watch(usersRepositoryProvider);
  return repository.getMe();
}
