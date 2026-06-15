import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/features/agent/home/presentation/pages/home_page.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/pages/customer_order_page.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/pages/edit_order_page.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/pages/order_detail_page.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/pages/order_inform_page.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/pages/item_details_page.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/page/order_form_page.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/presentation/pages/scan_page.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/pages/profile_page.dart';
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
      GoRoute(path: RouteNames.agentProfile, builder: (_, _) => ProfilePage()),
      GoRoute(
        path: RouteNames.agentOrderCustomers,
        builder: (_, _) => CreateOrderCustomerPage(),
      ),
      GoRoute(
        path: RouteNames.orderDetails,
        builder: (context, state) {
          final orderId = state.extra as int;

          return OrderDetailsPage(orderId: orderId);
        },
      ),
      GoRoute(
        path: RouteNames.scanner,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return ScanItemPage(
            orderId: extra["orderId"],
            agentId: extra["agentId"],
          );
        },
      ),
      GoRoute(
        path: RouteNames.orderItems,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return ItemDetailsPage(
            orderId: extra['orderId'],
            qrCode: extra['qrCode'],
            agentId: extra['agentId'],
          );
        },
      ),
      GoRoute(
        path: RouteNames.po,
        builder: (context, state) {
          final orderId = state.extra as int;

          return OrderInvoicePage(orderId: orderId);
        },
      ),

      GoRoute(
        path: RouteNames.orderInform,
        builder: (context, state) {
          final orderId = state.extra as int;

          return OrderInformPage(orderId: orderId);
        },
      ),

      GoRoute(
        path: RouteNames.editOrder,
        builder: (context, state) {
          final orderId = state.extra as int;

          return EditOrderPage(orderId: orderId);
        },
      ),
    ],
  );
}
