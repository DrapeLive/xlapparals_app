import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/features/agent/home/presentation/pages/home_page.dart';
import 'package:xlapparals_app/features/auth/presentation/pages/login_page.dart';
import 'package:xlapparals_app/shared/services/secure_storage_service.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.login,

    redirect: (context, state) async {
      final token = await SecureStorageService().getAccessToken();

      final isLoggedIn = token != null && token.isNotEmpty;

      final isLoginRoute = state.matchedLocation == RouteNames.login;

      if (!isLoggedIn && !isLoginRoute) {
        return RouteNames.login;
      }

      if (isLoggedIn && isLoginRoute) {
        return RouteNames.agentHome;
      }

      return null;
    },

    routes: [
      GoRoute(path: RouteNames.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: RouteNames.agentHome, builder: (_, _) => HomePage()),
    ],
  );
}
