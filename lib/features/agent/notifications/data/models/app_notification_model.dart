import 'package:xlapparals_app/features/agent/notifications/domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    super.itemId,
    super.orderId,
    required super.isRead,
    required super.createdAt,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json["id"],
      title: json["title"],
      body: json["body"] ?? "",
      type: json["notification_type"] ?? "",
      itemId: json["item_id"],
      orderId: json["order_id"],
      isRead: json["is_read"] ?? false,
      createdAt: DateTime.parse(json["created_at"]),
    );
  }

  static List<AppNotificationModel> listFromJson(List<dynamic> json) {
    return json
        .map((e) => AppNotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}