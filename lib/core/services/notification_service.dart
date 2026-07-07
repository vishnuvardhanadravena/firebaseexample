import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/logger.dart';

/// ===============================================================
/// NotificationService
/// ===============================================================
///
/// Handles:
/// • Firebase Cloud Messaging (FCM)
/// • Notification Permission
/// • FCM Token
/// • Token Refresh
///
///
/// Usage:
///
/// await NotificationService.initialize();
///
///
/// Get Token
///
/// final token = await NotificationService.fcmToken;
///
///
/// Logout
///
/// await NotificationService.deleteToken();
///
/// ===============================================================

class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  ///---------------------------------------------------------------
  /// Initialize Notification Service
  ///---------------------------------------------------------------
  ///
  /// Call once from bootstrap.dart
  ///
  /// Example:
  ///
  /// await NotificationService.initialize();
  ///
  static Future<void> initialize() async {
    await _requestPermission();

    await _initializeLocalNotification();

    _configureForegroundNotification();

    _configureNotificationClick();

    await _printToken();

    _listenTokenRefresh();
  }

  ///---------------------------------------------------------------
  /// Request Notification Permission
  ///---------------------------------------------------------------
  ///
  /// Android 13+
  /// iOS
  ///
  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        AppLogger.success("Notification Permission Granted");
        break;

      case AuthorizationStatus.provisional:
        AppLogger.warning("Notification Permission Provisional");
        break;

      case AuthorizationStatus.denied:
        AppLogger.error("Notification Permission Denied");
        break;

      case AuthorizationStatus.notDetermined:
        AppLogger.warning("Notification Permission Not Determined");
        break;
    }
  }

  ///---------------------------------------------------------------
  /// Get FCM Token
  ///---------------------------------------------------------------
  ///
  /// Example:
  ///
  /// final token = await NotificationService.fcmToken;
  ///
  static Future<String?> get fcmToken async {
    final fcmtoken = _messaging.getToken();
    AppLogger.info("FCMTOKEN==>,${fcmtoken.toString()}");
    return fcmtoken;
  }

  ///---------------------------------------------------------------
  /// Print Token
  ///---------------------------------------------------------------
  ///
  /// Debug only.
  ///
  static Future<void> _printToken() async {
    final token = await fcmToken;

    AppLogger.line();

    AppLogger.info("FCM TOKEN");

    AppLogger.debug(token ?? "NULL");

    AppLogger.line();
  }

  ///---------------------------------------------------------------
  /// Listen Token Refresh
  ///---------------------------------------------------------------
  ///
  /// Whenever Firebase generates a new token,
  /// update it to your backend.
  ///
  static void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) async {
      AppLogger.success("FCM Token Refreshed");

      AppLogger.debug(token);

      /// TODO
      ///
      /// await authRepository.updateFCMToken(token);
    });
  }

  ///---------------------------------------------------------------
  /// Delete Token
  ///---------------------------------------------------------------
  ///
  /// Call during Logout
  ///
  /// Example:
  ///
  /// await NotificationService.deleteToken();
  ///
  static Future<void> deleteToken() async {
    await _messaging.deleteToken();

    AppLogger.warning("FCM Token Deleted");
  }

  ///===============================================================
  /// Local Notification Plugin
  ///===============================================================

  static final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  ///===============================================================
  /// Android Notification Channel
  ///===============================================================

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'default_channel',
    'Default Notifications',
    description: 'General Notifications',
    importance: Importance.high,
  );

  ///---------------------------------------------------------------
  /// Initialize Local Notification
  ///---------------------------------------------------------------
  ///
  /// Called automatically inside initialize()
  ///
  /// Example
  ///
  /// await _initializeLocalNotification();
  ///
  static Future<void> _initializeLocalNotification() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotification.initialize(
      settings: settings,

      /// Local Notification Click
      onDidReceiveNotificationResponse: (response) {
        _onNotificationClick(response.payload);
      },
    );

    if (Platform.isAndroid) {
      await _localNotification
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    }
  }

  ///---------------------------------------------------------------
  /// Foreground Notification
  ///---------------------------------------------------------------
  ///
  /// Firebase doesn't display notifications
  /// automatically while the app is open.
  ///
  /// So we convert Firebase Notification
  /// into Local Notification.
  ///
  /// Example
  ///
  /// Firebase
  ///      ↓
  ///
  /// Foreground
  ///      ↓
  ///
  /// Local Notification
  ///
  static void _configureForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;

      if (notification == null) return;

      await _localNotification.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default Notifications',
            channelDescription: 'General Notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data["route"],
      );
    });
  }

  //===============================================================
  // PART 3
  // Background Notification
  // Notification Click
  // Terminated State
  // Navigation
  //===============================================================

  ///---------------------------------------------------------------
  /// Background Handler
  ///---------------------------------------------------------------
  ///
  /// Register this inside bootstrap.dart
  ///
  /// FirebaseMessaging.onBackgroundMessage(
  ///     NotificationService.firebaseMessagingBackgroundHandler,
  /// );
  ///
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    AppLogger.info("Background Notification Received");

    AppLogger.debug(message.data.toString());
  }

  ///---------------------------------------------------------------
  /// Configure Notification Click
  ///---------------------------------------------------------------
  ///
  /// Called when user taps notification
  /// while app is in background.
  ///
  static void _configureNotificationClick() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _onNotificationClick(message.data["route"]);
    });

    _checkInitialMessage();
  }

  ///---------------------------------------------------------------
  /// App Opened From Terminated State
  ///---------------------------------------------------------------
  ///
  /// If app was killed and user taps notification.
  ///
  static Future<void> _checkInitialMessage() async {
    final message = await _messaging.getInitialMessage();

    if (message == null) return;

    _onNotificationClick(message.data["route"]);
  }

  ///---------------------------------------------------------------
  /// Notification Click
  ///---------------------------------------------------------------
  ///
  /// payload Example
  ///
  /// home
  ///
  /// profile
  ///
  /// order/15
  ///
  static void _onNotificationClick(String? payload) {
    if (payload == null) return;

    AppLogger.info("Notification Click : $payload");

    /// TODO
    ///
    /// Navigate using GoRouter
    ///
    /// Example
    ///
    /// AppRouter.router.go(payload);
  }
}
