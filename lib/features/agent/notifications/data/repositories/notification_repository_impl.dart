import 'package:xlapparals_app/features/agent/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:xlapparals_app/features/agent/notifications/domain/entities/app_notification.dart';
import 'package:xlapparals_app/features/agent/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AppNotification>> getNotifications({int limit = 100}) async {
    return remoteDataSource.getNotifications(limit: limit);
  }

  @override
  Future<int> getUnreadCount() async {
    return remoteDataSource.getUnreadCount();
  }

  @override
  Future<void> markRead(int id) async {
    return remoteDataSource.markRead(id);
  }

  @override
  Future<void> markAllRead() async {
    return remoteDataSource.markAllRead();
  }

  @override
  Future<void> delete(int id) async {
    return remoteDataSource.delete(id);
  }
}