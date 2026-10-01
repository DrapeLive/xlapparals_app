class ApiConstants {
  ApiConstants._();

  // static const String baseUrl = "https://stock-flow-tnwn.onrender.com/api";
  static const String baseUrl = "https://backend.xlapparals.in/api";
  // static const String baseUrl = "http://localhost:8000/api";

  static const Duration connectTimeout = Duration(seconds: 60);

  static const Duration receiveTimeout = Duration(seconds: 60);

  static const String login = "/auth/login/";
  static const String refresh = "/auth/refresh/";
  static const String customers = "/customers/";

  /// Registers the agent's FCM device token (POST body: agent, token, platform).
  static const String registerDevice = "/agents/device-token/";

  static const String notifications = "/notification/list/";
  static const String notificationUnreadCount = "/notification/unread-count/";
  static const String notificationMarkAllRead = "/notification/mark-all-read/";

  static String markNotificationRead(int id) => "/notification/$id/mark-read/";

  static String deleteNotification(int id) => "/notification/$id/";
}
