import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/notifications/domain/entities/app_notification.dart';
import 'package:xlapparals_app/features/agent/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:xlapparals_app/features/agent/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:xlapparals_app/features/agent/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:xlapparals_app/features/agent/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:xlapparals_app/features/agent/notifications/domain/usecases/mark_notification_read_usecase.dart';

import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final MarkNotificationReadUseCase markReadUseCase;
  final MarkAllNotificationsReadUseCase markAllReadUseCase;
  final DeleteNotificationUseCase deleteUseCase;

  NotificationsBloc({
    required this.getNotificationsUseCase,
    required this.getUnreadCountUseCase,
    required this.markReadUseCase,
    required this.markAllReadUseCase,
    required this.deleteUseCase,
  }) : super(const NotificationsInitial()) {
    on<FetchNotifications>(_fetch);
    on<MarkNotificationRead>(_markRead);
    on<MarkAllNotificationsRead>(_markAllRead);
    on<DeleteNotification>(_delete);
  }

  Future<void> _fetch(
    FetchNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) {
      emit(const NotificationsLoading());
    }

    try {
      final results = await Future.wait<dynamic>([
        getNotificationsUseCase(),
        getUnreadCountUseCase(),
      ]);
      final notifications = results[0] as List<AppNotification>;
      final unread = results[1] as int;

      emit(NotificationsLoaded(notifications, unread));
    } on DioException catch (e) {
      if (state is NotificationsLoaded) return;
      emit(NotificationsError(e.message ?? "Failed to load notifications"));
    } catch (_) {
      if (state is NotificationsLoaded) return;
      emit(const NotificationsError("Something went wrong"));
    }
  }

  Future<void> _markRead(
    MarkNotificationRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final updated = _updateItem(current, event.notificationId, isRead: true);
    if (updated == null) return;

    emit(updated);
    try {
      await markReadUseCase(event.notificationId);
    } catch (_) {}
  }

  Future<void> _markAllRead(
    MarkAllNotificationsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final notifications = current.notifications
        .map((n) => n.isRead ? n : _withRead(n))
        .toList();

    emit(NotificationsLoaded(notifications, 0));
    try {
      await markAllReadUseCase();
    } catch (_) {}
  }

  Future<void> _delete(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final index = current.notifications
        .indexWhere((n) => n.id == event.notificationId);
    if (index == -1) return;

    final removed = current.notifications[index];
    final notifications = [...current.notifications]..removeAt(index);
    final unread = removed.isRead
        ? current.unreadCount
        : (current.unreadCount > 0 ? current.unreadCount - 1 : 0);

    emit(NotificationsLoaded(notifications, unread));
    try {
      await deleteUseCase(event.notificationId);
    } catch (_) {}
  }

  NotificationsLoaded? _updateItem(
    NotificationsLoaded current,
    int id, {
    required bool isRead,
  }) {
    final index = current.notifications.indexWhere((n) => n.id == id);
    if (index == -1) return null;

    final target = current.notifications[index];
    if (target.isRead == isRead) return current;

    final notifications = [...current.notifications];
    notifications[index] = isRead ? _withRead(target) : target;
    final unread = isRead && current.unreadCount > 0
        ? current.unreadCount - 1
        : current.unreadCount;

    return NotificationsLoaded(notifications, unread);
  }

  AppNotification _withRead(AppNotification n) {
    return AppNotification(
      id: n.id,
      title: n.title,
      body: n.body,
      type: n.type,
      itemId: n.itemId,
      orderId: n.orderId,
      isRead: true,
      createdAt: n.createdAt,
    );
  }
}