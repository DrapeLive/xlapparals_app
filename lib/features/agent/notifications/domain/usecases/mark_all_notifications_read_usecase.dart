import 'package:xlapparals_app/features/agent/notifications/domain/repositories/notification_repository.dart';

class MarkAllNotificationsReadUseCase {
  final NotificationRepository repository;

  MarkAllNotificationsReadUseCase(this.repository);

  Future<void> call() {
    return repository.markAllRead();
  }
}