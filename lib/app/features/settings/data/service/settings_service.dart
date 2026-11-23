import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/api_helper/response_client.dart';
import 'package:syncup/app/core/constants/typedefs.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(ref.watch(dioClientProvider));
});

class SettingsService {
  final DioClient client;
  SettingsService(this.client);

  // 1. POST /auth/change-password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final res = ResponseClient<dynamic>(
      await client.post(
        Endpoints.changePassword,
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 2. GET /users/:id
  Future<Json> getUserProfile(String userId) async {
    final res = ResponseClient<Json>(
      await client.get(Endpoints.user(userId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }

  // 3. PATCH /users/profile
  Future<Json> updateProfile(Map<String, dynamic> data) async {
    final res = ResponseClient<Json>(
      await client.patch(
        Endpoints.usersProfile,
        body: data,
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }
}
