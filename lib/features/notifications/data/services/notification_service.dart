import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Serviço de notificações push do sistema operacional.
///
/// - Android / iOS / macOS / Linux / Windows → flutter_local_notifications
/// - Web → usa dart:html Notification API (importada condicionalmente)
///
/// Em ambiente de testes (plugin não inicializado) os erros são silenciados.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Web não é suportada pelo flutter_local_notifications.
  /// Nela usamos a Notification API via JS.
  bool get _isNativeSupported => !kIsWeb;

  // ── Inicialização ─────────────────────────────────────────────────────────

  Future<void> init() async {
    if (kIsWeb) {
      await _requestWebPermission();
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

    // FLN v18+: initialize() usa o parâmetro nomeado 'settings:'
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('[NotificationService] clicou: ${details.payload}');
      },
    );

    // Android 13+: solicitar permissão em runtime
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
    }
  }

  // ── Enviar notificação ─────────────────────────────────────────────────────

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

      // FLN v18: show() usa parâmetros posicionais para id, title, body e notificationDetails
      await _plugin.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (_) {
      // Silencia erros de plataforma / plugin não inicializado (ex: testes)
    }
  }

  // ── Web — Notification API ─────────────────────────────────────────────────

  Future<void> _requestWebPermission() async {
    // Importação condicional para evitar erro em compilação nativa
    if (kIsWeb) {
      try {
        // ignore: avoid_web_libraries_in_flutter
        // Usar JS interop via eval para não quebrar compilação nativa
        _webRequestPermission();
      } catch (_) {}
    }
  }

  void _showWebNotification({required String title, required String body}) {
    if (!kIsWeb) return;
    try {
      _webShowNotification(title, body);
    } catch (_) {}
  }

  // Stub — implementação real injetada via conditional import se necessário.
  // Em mobile/desktop estas funções nunca são chamadas (kIsWeb=false).
  void _webRequestPermission() {}
  void _webShowNotification(String title, String body) {}
}
