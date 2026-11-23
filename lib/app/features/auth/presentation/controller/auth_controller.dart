import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/features/auth/data/models/user_model.dart';
import 'package:syncup/app/features/auth/data/service/auth_service.dart';
import 'package:syncup/app/services/notification_service.dart';
import 'package:syncup/app/services/storage_service.dart';

// 1. Public Provider
final authProvider = Provider<_AuthLogic>(
  (ref) => _AuthLogic(
    ref: ref,
    service: ref.watch(authServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  ),
);

// 2. Logic Implementation
class _AuthLogic extends _AuthStates {
  final AuthService service;
  final StorageService storageService;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  _AuthLogic({
    required super.ref,
    required this.service,
    required this.storageService,
  });

  Future<void> login() async {
    try {
      if (!formKey.currentState!.validate()) return;
      isLoading.state = true;
      isError.state = '';

      final response = await service.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Persist auth data
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await storageService.saveUser(response.user.toJson());

      // Sync device push token with backend
      ref.read(notificationServiceProvider).syncTokenWithBackend();

      currentUser.state = response.user;
      isSuccess.state = true;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } catch (e) {
      isError.state = 'An unexpected error occurred';
    } finally {
      isLoading.state = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.state = true;
      await ref.read(notificationServiceProvider).unregisterToken();
      await service.logout();
    } catch (_) {
      // Continue client logout even if network call fails
    } finally {
      await storageService.clearAuthData();
      currentUser.state = null;
      isLoading.state = false;
      isLoggedOut.state = true;
    }
  }

  void resetStates() {
    isSuccess.state = false;
    isLoggedOut.state = false;
    isError.state = '';
  }
}

// 3. States Definition
class _AuthStates {
  final Ref ref;
  final CustomState<bool> isLoading;
  final CustomState<bool> isSuccess;
  final CustomState<bool> isLoggedOut;
  final CustomState<String> isError;
  final CustomState<UserModel?> currentUser;

  _AuthStates({required this.ref})
      : isLoading = CustomState(ref, false),
        isSuccess = CustomState(ref, false),
        isLoggedOut = CustomState(ref, false),
        isError = CustomState(ref, ''),
        currentUser = CustomState(ref, null);
}
