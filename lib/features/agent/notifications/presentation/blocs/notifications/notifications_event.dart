abstract class NotificationsEvent {
  const NotificationsEvent();
}

class FetchNotifications extends NotificationsEvent {
  const FetchNotifications();
}

class MarkNotificationRead extends NotificationsEvent {
  final int notificationId;

  const MarkNotificationRead(this.notificationId);
}

class MarkAllNotificationsRead extends NotificationsEvent {
  const MarkAllNotificationsRead();
}

class DeleteNotification extends NotificationsEvent {
  final int notificationId;

  const DeleteNotification(this.notificationId);
}