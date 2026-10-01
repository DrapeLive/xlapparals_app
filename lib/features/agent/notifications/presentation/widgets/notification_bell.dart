import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/notifications/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:xlapparals_app/features/agent/notifications/presentation/blocs/notifications/notifications_state.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        final unread = state is NotificationsLoaded ? state.unreadCount : 0;

        return GestureDetector(
          onTap: () => context.go(RouteNames.notifications),
          child: Container(
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Badge(
              isLabelVisible: unread > 0,
              backgroundColor: AppColors.orange,
              label: Text(
                unread > 99 ? "99+" : "$unread",
                style: const TextStyle(fontSize: 9),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Colors.black,
                size: 26,
              ),
            ),
          ),
        );
      },
    );
  }
}