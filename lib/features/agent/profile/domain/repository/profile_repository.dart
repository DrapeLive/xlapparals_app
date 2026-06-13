import 'package:xlapparals_app/features/agent/profile/domain/entities/agent.dart';

abstract class ProfileRepository {
  Future<Agent?> getProfile();
}
