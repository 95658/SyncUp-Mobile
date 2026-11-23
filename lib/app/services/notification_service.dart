import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[FCM Background] Handling message ID: ${message.messageId}');
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final storage = ref.watch(storageServiceProvider);
  return NotificationService(dioClient, storage);
});

class NotificationService {
  final DioClient _dio;
  final StorageService _storage;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const String channelId = 'syncup_notifications';
  static const String channelName = 'SyncUp Notifications';
  static const String channelDesc = 'Notifications for messages, task assignments, and workspace updates.';

  NotificationService(this._dio, this._storage);

  Future<void> initialize() async {
    try {
      // 1. Initialize Firebase Core
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // 2. Set background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // 3. Request permissions
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');

      // 4. Initialize Local Notifications for foreground heads-up banners
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint('[FCM] Local notification tapped payload: ${response.payload}');
        },
      );

      // Create Android Channel
      if (Platform.isAndroid) {
        const androidChannel = AndroidNotificationChannel(
          channelId,
          channelName,
          description: channelDesc,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );
        await _localNotifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(androidChannel);
      }

      // Foreground presentation options for iOS
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 5. Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[FCM Foreground] Received: ${message.notification?.title}');
        _showForegroundNotification(message);
      });

      // 6. Handle notification click when app opened from background/terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[FCM Opened App] Tapped: ${message.data}');
      });

      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('[FCM Initial] Launched from: ${initialMessage.data}');
      }

      // 7. Sync FCM Token if logged in
      await syncTokenWithBackend();

      // Listen for token refresh
      messaging.onTokenRefresh.listen((newToken) async {
        debugPrint('[FCM] Token refreshed: $newToken');
        await syncTokenWithBackend(overrideToken: newToken);
      });
    } catch (e, stack) {
      debugPrint('[FCM] Error initializing push notifications: $e\n$stack');
    }
  }

  Future<void> syncTokenWithBackend({String? overrideToken}) async {
    final token = await _storage.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('[FCM] User not logged in, skipping device token sync');
      return;
    }

    try {
      final fcmToken = overrideToken ?? await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('[FCM] No FCM token available to sync');
        return;
      }

      final platform = Platform.isIOS ? 'IOS' : 'ANDROID';
      debugPrint('[FCM] Syncing token with backend for platform: $platform');

      await _dio.post(
        Endpoints.notificationDeviceToken,
        body: {
          'token': fcmToken,
          'platform': platform,
        },
      );
      debugPrint('[FCM] Device token synced successfully with backend');
    } catch (e) {
      debugPrint('[FCM] Failed to sync device token with backend: $e');
    }
  }

  Future<void> unregisterToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        await _dio.delete(
          Endpoints.notificationDeviceToken,
          body: {'token': fcmToken},
        );
        debugPrint('[FCM] Device token removed on logout');
      }
    } catch (e) {
      debugPrint('[FCM] Failed to unregister device token: $e');
    }
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      color: AppColors.primary,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }
}
