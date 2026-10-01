import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/cache/api_cache_service.dart';
import 'core/network/dio_interceptor.dart';
import 'core/routes/app_router.dart';
import 'core/routes/route_name.dart';
import 'injection_container.dart' as di;
import 'shared/services/local_cache_service.dart';
import 'shared/services/notification_service.dart';
import 'shared/services/secure_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase must start before runApp so the messaging singleton + background
  // isolate callbacks (below) are available for the whole app lifetime.
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Firebase unavailable (google-services.json missing?): $e');
  }

  await di.init();

  // Session expiry (refresh failed / refresh token missing) must behave like
  // a sign-out: drop every cache layer and return to the login screen.
  SessionMediator.onSessionExpired = () async {
    await di.sl<SecureStorageService>().clear();
    di.sl<ApiCacheService>().invalidateAll();
    await di.sl<LocalCacheService>().clearAll();
    AppRouter.router.go(RouteNames.login);
  };

  // Foreground/background notification wiring. Safe no-op when Firebase is
  // not configured yet.
  await di.sl<NotificationService>().initialize();

  runApp(const App());
}
