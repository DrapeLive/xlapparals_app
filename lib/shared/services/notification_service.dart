import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xlapparals_app/core/constants/api_constants.dart';
import 'package:xlapparals_app/core/routes/app_router.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

const String _kChannelId = 'orders_updates';
const String _kChannelName = 'Order & Item Updates';
const String _kChannelDescription =
    'New assigned items and out-of-stock alerts';

const AndroidNotificationDetails _channelDetails = AndroidNotificationDetails(
  _kChannelId,
  _kChannelName,
  channelDescription: _kChannelDescription,
  importance: Importance.high,
  priority: Priority.high,
);

/// Handles notifications while the app is fully terminated or backgrounded.
///
/// Must be a top-level function (Firebase runs it on a separate isolate).
/// Messages that carry an FCM `notification` block are displayed automatically
/// by the system, so we only surface data-only messages ourselves.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) return;

  final title = message.data['title']?.toString() ?? 'XL Apparels';
  final body = message.data['body']?.toString() ?? 'New update';
  final fln = FlutterLocalNotificationsPlugin();
  await fln.initialize(settings: const InitializationSettings());
  await fln.show(
    id: message.messageId.hashCode,
    title: title,
    body: body,
    notificationDetails: const NotificationDetails(android: _channelDetails),
  );
}

class NotificationService {
  static const _kTokenKey = 'fcm_token_sent';
  static const _kRegisteredUserIdKey = 'fcm_user_id_sent';

  final Dio dio;
  final UserStorageService userStorage;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Called after a notification banner is shown in the foreground so the
  /// Home bell's badge can refresh without user interaction.
  void Function()? onForegroundMessage;

  bool _initialized = false;

  NotificationService(this.dio, this.userStorage);

  /// Called once from [main]. Safe to call without Firebase configured -
  /// the app still runs, just without push notifications.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase init failed (google-services.json missing?): $e');
      return;
    }

    try {
      await _setupNotifications();
      _initialized = true;
    } catch (e) {
      debugPrint('Notification setup failed: $e');
    }
  }

  Future<void> _setupNotifications() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (kDebugMode) {
      debugPrint('FCM permission: ${settings.authorizationStatus}');
    }

    if (!kIsWeb) {
      await _localNotifications.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('ic_stat_notification'),
        ),
        onDidReceiveNotificationResponse: _onLocalNotificationTap,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(_kChannelId, _kChannelName,
                description: _kChannelDescription,
                importance: Importance.high),
          );
    }

    // Foreground app: the system does not show FCM banners, so display a
    // local notification ourselves.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Tapped while app was in the background.
    FirebaseMessaging.onMessageOpenedApp.listen(_openForMessage);

    // Tapped while app was terminated.
    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _openForMessage(initial),
      );
    }

    // Re-register whenever Firebase rotates the token.
    messaging.onTokenRefresh.listen((token) => _sendToken(token));

    // Register right away too (idempotent; server upserts).
    unawaited(registerDeviceToken());
  }

  void _onForegroundMessage(RemoteMessage message) {
    final title =
        message.notification?.title ?? message.data['title']?.toString();
    final body =
        message.notification?.body ?? message.data['body']?.toString();
    if (title == null) return;

    _showLocalNotification(
      title,
      body ?? '',
      payload: jsonEncode(_payloadItems(message)),
    );

    onForegroundMessage?.call();
  }

  void _openForMessage(RemoteMessage message) {
    _navigate(jsonEncode(_payloadItems(message)));
  }

  Map<String, dynamic> _payloadItems(RemoteMessage message) {
    return {
      'type': message.data['type'] ?? '',
      'item_id': message.data['item_id'],
    };
  }

  Future<void> _showLocalNotification(
    String title,
    String body, {
    String? payload,
  }) async {
    if (kIsWeb) return;
    try {
      await _localNotifications.show(
        id: DateTime.now().millisecondsSinceEpoch.remainder(1000000),
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(android: _channelDetails),
        payload: payload,
      );
    } catch (e) {
      debugPrint('Unable to show notification: $e');
    }
  }

  Future<void> _onLocalNotificationTap(NotificationResponse response) async {
    final payload = response.payload;
    if (payload == null) return;
    _navigate(payload);
  }

  /// Opens the in-app notification center on any notification tap. The list
  /// page deep-links further (orders vs items) from the stored record.
  void _navigate(String payload) {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      debugPrint('Notification tap: type=${data['type']} '
          'itemId=${data['item_id']}');
    } catch (_) {}
    AppRouter.router.go(RouteNames.notifications);
  }

  /// Registers the FCM token for the currently logged-in agent.
  ///
  /// Non-fatal: if the backend's device-token endpoint is not implemented yet,
  /// this logs and continues.
  Future<void> registerDeviceToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = await userStorage.getUserId();
      if (userId == null) return;

      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();
      if (token == null || token.isEmpty) return;

      final alreadySent = prefs.getString(_kTokenKey);
      final registeredUser = prefs.getInt(_kRegisteredUserIdKey);
      if (alreadySent == token && registeredUser == userId) return;

      await _sendToken(token);
      await prefs.setString(_kTokenKey, token);
      await prefs.setInt(_kRegisteredUserIdKey, userId);
    } catch (e) {
      debugPrint('FCM token registration skipped: $e');
    }
  }

  Future<void> _sendToken(String token) async {
    try {
      final userId = await userStorage.getUserId();
      if (userId == null) return;
      await dio.post(
        ApiConstants.registerDevice,
        data: {
          'agent': userId,
          'token': token,
          'platform': 'android',
        },
      );
    } on DioException catch (e) {
      debugPrint(
        'FCM token send failed (status ${e.response?.statusCode}): '
        '${e.message}',
      );
    } catch (e) {
      debugPrint('FCM token send failed: $e');
    }
  }
}