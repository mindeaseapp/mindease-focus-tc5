import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mindease_focus/features/notifications/data/services/notification_service_stub.dart'
    if (dart.library.html) 'package:mindease_focus/features/notifications/data/services/notification_service_web.dart'
    as web_impl;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool get _isNativeSupported => !kIsWeb;

  Future<void> init() async {
    if (kIsWeb) {
      _requestWebPermission();
      return;
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: android,
      iOS: darwin,
      macOS: darwin,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('[NotificationService] clicou: ${details.payload}');
      },
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      final android =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) {
      _showWebNotification(title: title, body: body);
      return;
    }

    if (!_isNativeSupported) return;

    try {
      const android = AndroidNotificationDetails(
        'mindease_pomodoro',
        'MindEase — Pomodoro',
        channelDescription: 'Avisos de conclusão do timer Pomodoro',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      const darwin = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const details = NotificationDetails(
        android: android,
        iOS: darwin,
        macOS: darwin,
      );

      await _plugin.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (_) {
    }
  }

  void _requestWebPermission() {
    if (kIsWeb) {
      try {
        web_impl.webRequestPermission();
      } catch (_) {}
    }
  }

  void _showWebNotification({required String title, required String body}) {
    if (!kIsWeb) return;
    try {
      web_impl.webShowNotification(title, body);
    } catch (_) {}
  }
}
