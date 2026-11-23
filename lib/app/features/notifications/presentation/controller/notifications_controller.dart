import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/features/notifications/data/models/notification_model.dart';
import 'package:syncup/app/features/notifications/data/service/notifications_service.dart';

final notificationsProvider = Provider<_NotificationsLogic>(
  (ref) => _NotificationsLogic(
    ref: ref,
    service: ref.watch(notificationsServiceProvider),
  ),
);

class _NotificationsLogic extends _NotificationsStates {
  final NotificationsService service;

  _NotificationsLogic({
    required super.ref,
    required this.service,
  });

  Future<void> fetchNotifications() async {
    try {
      isLoading.state = true;
      isError.state = '';
      final list = await service.getNotifications();
      notifications.state = list;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } catch (e) {
      isError.state = 'Failed to load notifications';
    } finally {
      isLoading.state = false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await service.markAsRead(id);
      notifications.state = notifications.state.map((n) {
        if (n.id == id) {
          return NotificationModel(
            id: n.id,
            title: n.title,
            message: n.message,
            type: n.type,
            isRead: true,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await service.markAllAsRead();
      notifications.state = notifications.state.map((n) {
        return NotificationModel(
          id: n.id,
          title: n.title,
          message: n.message,
          type: n.type,
          isRead: true,
          createdAt: n.createdAt,
        );
      }).toList();
    } catch (_) {}
  }
}

class _NotificationsStates {
  final Ref ref;
  final CustomState<bool> isLoading;
  final CustomState<String> isError;
  final CustomState<List<NotificationModel>> notifications;

  _NotificationsStates({required this.ref})
      : isLoading = CustomState(ref, false),
        isError = CustomState(ref, ''),
        notifications = CustomState(ref, []);
}
