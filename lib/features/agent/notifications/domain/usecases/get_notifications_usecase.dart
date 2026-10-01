import 'package:xlapparals_app/features/agent/notifications/domain/entities/app_notification.dart';
import 'package:xlapparals_app/features/agent/notifications/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<AppNotification>> call({int limit = 100}) {
    return repository.getNotifications(limit: limit);
  }
}