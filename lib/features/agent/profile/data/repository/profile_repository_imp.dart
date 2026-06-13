import 'package:xlapparals_app/features/agent/profile/domain/entities/agent.dart';
import 'package:xlapparals_app/features/agent/profile/domain/repository/profile_repository.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final UserStorageService storageService;

  const ProfileRepositoryImpl(this.storageService);

  @override
  Future<Agent?> getProfile() async {
    return await storageService.getAgent();
  }
}
