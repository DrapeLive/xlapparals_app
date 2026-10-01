import 'package:dio/dio.dart';
import 'package:xlapparals_app/core/constants/api_constants.dart';

import '../models/app_notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<AppNotificationModel>> getNotifications({int limit = 100});

  Future<int> getUnreadCount();

  Future<void> markRead(int id);

  Future<void> markAllRead();

  Future<void> delete(int id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AppNotificationModel>> getNotifications({int limit = 100}) async {
    final response = await dio.get(
      ApiConstants.notifications,
      queryParameters: {"limit": limit},
    );
    return AppNotificationModel.listFromJson(response.data as List);
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await dio.get(ApiConstants.notificationUnreadCount);
    return (response.data["unread_count"] as num?)?.toInt() ?? 0;
  }

  @override
  Future<void> markRead(int id) async {
    await dio.post(ApiConstants.markNotificationRead(id));
  }

  @override
  Future<void> markAllRead() async {
    await dio.post(ApiConstants.notificationMarkAllRead);
  }

  @override
  Future<void> delete(int id) async {
    await dio.delete(ApiConstants.deleteNotification(id));
  }
}