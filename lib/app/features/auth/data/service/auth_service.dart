import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/api_helper/response_client.dart';
import 'package:syncup/app/core/constants/typedefs.dart';
import 'package:syncup/app/features/auth/data/models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(dioClientProvider));
});

class AuthService {
  final DioClient client;
  AuthService(this.client);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.login,
        body: {
          'email': email.trim(),
          'password': password,
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    if (res.data == null) {
      throw ApiExceptionMessage('Invalid response format from server');
    }

    return AuthResponseModel.fromJson(res.data!);
  }

  // Accept invitation token & create password
  Future<AuthResponseModel> acceptInvitation({
    required String token,
    required String name,
    required String password,
  }) async {
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.acceptInvitation,
        body: {
          'token': token.trim(),
          'name': name.trim(),
          'password': password,
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return AuthResponseModel.fromJson(res.data!);
  }

  // Refresh access token
  Future<String?> refreshToken(String refreshToken) async {
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.refresh,
        body: {'refreshToken': refreshToken},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data?['accessToken'] as String?;
  }

  Future<UserModel> getMe() async {
    final res = ResponseClient<Json>(
      await client.get(Endpoints.me),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return UserModel.fromJson(res.data!);
  }

  Future<void> logout() async {
    final res = ResponseClient(
      await client.post(Endpoints.logout),
    );
    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }
  }
}
