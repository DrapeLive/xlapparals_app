class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "https://backend.xlapparals.in/api";

  static const Duration connectTimeout = Duration(seconds: 60);

  static const Duration receiveTimeout = Duration(seconds: 60);

  static const String login = "/auth/login/";
  static const String customers = "/customers/";
}
