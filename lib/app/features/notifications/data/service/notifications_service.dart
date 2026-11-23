import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/api_helper/response_client.dart';
import 'package:syncup/app/core/constants/typedefs.dart';
import 'package:syncup/app/features/notifications/data/models/notification_model.dart';

final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return NotificationsService(ref.watch(dioClientProvider));
});

class NotificationsService {
  final DioClient client;

  NotificationsService(this.client);

  // 1. GET /notifications
  Future<List<NotificationModel>> getNotifications() async {
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.notifications),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    final data = res.data;
    if (data is List) {
      return data.map((item) => NotificationModel.fromJson(item as Json)).toList();
    }
    return [];
  }

  // 2. PATCH /notifications/:id/read
  Future<bool> markAsRead(String id) async {
    final res = ResponseClient<dynamic>(
      await client.patch(Endpoints.readNotification(id)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 3. PATCH /notifications/read-all
  Future<bool> markAllAsRead() async {
    final res = ResponseClient<dynamic>(
      await client.patch(Endpoints.readAllNotifications),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }
}
