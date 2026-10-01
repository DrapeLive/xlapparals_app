import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../../shared/services/secure_storage_service.dart';

/// Fired when the session cannot be restored (refresh failed / no refresh
/// token). Wire it in `main.dart` to clear local state and return to login.
typedef SessionExpiredHandler = Future<void> Function();

class SessionMediator {
  static SessionExpiredHandler? onSessionExpired;
}

class AuthInterceptor extends Interceptor {
  static const String _retriedKey = 'auth_retried';

  final SecureStorageService storage;
  final Dio dio;

  Future<String?>? _refreshFuture;

  AuthInterceptor(this.storage, this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.getAccessToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final path = requestOptions.path;

    // Login/refresh calls are the source of a valid 401 (bad credentials),
    // not proof the session died - never refresh those.
    final isAuthPath =
        path.contains('/auth/login') || path.contains('/auth/refresh');

    if (err.response?.statusCode == 401 && !isAuthPath) {
      if (requestOptions.extra[_retriedKey] == true) {
        // A retried request also 401'd - the refresh token is dead too.
        await _expireSession();
      } else {
        final accessToken = await _tryRefreshAccessToken();

        if (accessToken != null) {
          requestOptions.headers['Authorization'] = 'Bearer $accessToken';
          requestOptions.extra[_retriedKey] = true;

          try {
            final response = await dio.fetch(requestOptions);
            handler.resolve(response);
            return;
          } catch (e) {
            // The replay itself failed (e.g. network) - surface it below.
          }
        } else {
          await _expireSession();
        }
      }
    }

    handler.next(err);
  }

  /// Exchanges the stored refresh token for a fresh access token.
  ///
  /// Concurrent 401s (orders + items fetched in parallel) share a single
  /// in-flight refresh so the backend is hit once, not N times. Once the
  /// attempt completes the future is cleared so the next 401 can try again.
  Future<String?> _tryRefreshAccessToken() async {
    final previous = _refreshFuture;
    if (previous != null) return previous;
    final future = _refresh();
    _refreshFuture = future;
    try {
      return await future;
    } finally {
      if (identical(_refreshFuture, future)) {
        _refreshFuture = null;
      }
    }
  }

  Future<String?> _refresh() async {
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: ApiConstants.connectTimeout,
        ),
      );
      final response = await refreshDio.post(
        ApiConstants.refresh,
        data: {'refresh': refreshToken},
      );

      final newAccess = response.data?['access'] as String?;
      if (newAccess == null || newAccess.isEmpty) return null;

      await storage.saveTokens(
        access: newAccess,
        refresh: response.data?['refresh'] as String? ?? refreshToken,
      );

      return newAccess;
    } catch (e) {
      return null;
    }
  }

  Future<void> _expireSession() async {
    final handler = SessionMediator.onSessionExpired;
    if (handler != null) {
      await handler();
    } else {
      await storage.clear();
    }
  }
}