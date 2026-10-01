import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/notifications/domain/entities/app_notification.dart';
import 'package:xlapparals_app/features/agent/notifications/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:xlapparals_app/features/agent/notifications/presentation/blocs/notifications/notifications_event.dart';
import 'package:xlapparals_app/features/agent/notifications/presentation/blocs/notifications/notifications_state.dart';
import 'package:xlapparals_app/shared/pages/error_page.dart';
import 'package:xlapparals_app/shared/pages/loading_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(FetchNotifications());
  }

  Future<void> _refresh() async {
    context.read<NotificationsBloc>().add(FetchNotifications());
  }

  void _open(AppNotification notification) {
    if (notification.orderId != null &&
        (notification.type == 'OUT_OF_STOCK' ||
            notification.type == 'STOCK_ALERT')) {
      context.go(RouteNames.orderDetails, extra: notification.orderId);
      return;
    }
    context.go(RouteNames.agentHome);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go(RouteNames.agentHome);
      },
      child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.agentHome),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              final unread =
                  state is NotificationsLoaded ? state.unreadCount : 0;
              if (unread == 0) return const SizedBox.shrink();
              return IconButton(
                tooltip: "Mark all as read",
                onPressed: () => context
                    .read<NotificationsBloc>()
                    .add(const MarkAllNotificationsRead()),
                icon: const Icon(Icons.done_all),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const LoadingPage(message: "Loading notifications...");
            }

            if (state is NotificationsError) {
              return ErrorPage(message: state.message, onRetry: _refresh);
            }

            if (state is NotificationsLoaded) {
              final notifications = state.notifications;

              if (notifications.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: LayoutBuilder(
                    builder: (context, constraints) => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.7,
                          child: const _EmptyState(),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: notifications.length,
                  separatorBuilder: (_, _) => const Divider(
                    height: 1,
                    indent: 68,
                    color: AppColors.border,
                  ),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _NotificationTile(
                      notification: notification,
                      onTap: () {
                        context.read<NotificationsBloc>().add(
                              MarkNotificationRead(notification.id),
                            );
                        _open(notification);
                      },
                      onDelete: () => context
                          .read<NotificationsBloc>()
                          .add(DeleteNotification(notification.id)),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.notifications_none, size: 90, color: AppColors.border),
        const SizedBox(height: 16),
        const Text(
          "No notifications yet",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          "Item assignments and stock alerts will show up here.",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(notification.type);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead
            ? Colors.transparent
            : AppColors.orange.withValues(alpha: 0.08),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_iconFor(notification.type), color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 5),
                          decoration: const BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _timeAgo(notification.createdAt),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
                color: AppColors.textPrimary,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

IconData _iconFor(String type) {
  switch (type) {
    case 'ITEMS_ASSIGNED':
    case 'ITEMS_TRANSFERRED':
    case 'ITEMS_COPIED':
      return Icons.inventory_2_outlined;
    case 'OUT_OF_STOCK':
    case 'STOCK_ALERT':
      return Icons.warning_amber_rounded;
    case 'NEW_CUSTOMER':
      return Icons.person_add_alt_1;
    default:
      return Icons.notifications_none;
  }
}

Color _colorFor(String type) {
  switch (type) {
    case 'ITEMS_ASSIGNED':
    case 'ITEMS_TRANSFERRED':
    case 'ITEMS_COPIED':
      return AppColors.primary;
    case 'OUT_OF_STOCK':
    case 'STOCK_ALERT':
      return AppColors.red;
    case 'NEW_CUSTOMER':
      return AppColors.green;
    default:
      return AppColors.textPrimary;
  }
}

String _timeAgo(DateTime time) {
  final diff = DateTime.now().difference(time);

  if (diff.inMinutes < 1) return "Just now";
  if (diff.inHours < 1) return "${diff.inMinutes}m ago";
  if (diff.inDays < 1) return "${diff.inHours}h ago";
  if (diff.inDays < 7) return "${diff.inDays}d ago";
  return "${time.day}/${time.month}/${time.year}";
}