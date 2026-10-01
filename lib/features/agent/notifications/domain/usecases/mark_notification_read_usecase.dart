import 'package:xlapparals_app/features/agent/notifications/domain/repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  Future<void> call(int id) {
    return repository.markRead(id);
  }
}