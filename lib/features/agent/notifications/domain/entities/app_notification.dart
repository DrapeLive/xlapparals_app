class AppNotification {
  final int id;

  final String title;

  final String body;

  final String type;

  final int? itemId;

  final int? orderId;

  final bool isRead;

  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.itemId,
    this.orderId,
    required this.isRead,
    required this.createdAt,
  });
}