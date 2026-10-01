import 'package:xlapparals_app/features/agent/notifications/domain/entities/app_notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications({int limit = 100});

  Future<int> getUnreadCount();

  Future<void> markRead(int id);

  Future<void> markAllRead();

  Future<void> delete(int id);
}