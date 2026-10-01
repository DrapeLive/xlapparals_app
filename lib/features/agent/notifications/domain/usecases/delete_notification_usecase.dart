import 'package:xlapparals_app/features/agent/notifications/domain/repositories/notification_repository.dart';

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<void> call(int id) {
    return repository.delete(id);
  }
}