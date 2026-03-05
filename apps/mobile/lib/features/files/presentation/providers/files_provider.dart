import 'package:mobile/core/network/api/export.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/files/data/files_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'files_provider.g.dart';

@riverpod
FilesRepository filesRepository(Ref ref) {
  final apiClient = ref.watch(apiClientWrapperProvider);
  return FilesRepository(service: FilesService(apiClient.dio));
}
