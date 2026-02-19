import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _permissionGranted = false;

  /// Inicializa o serviço de notificações
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Configuração Android
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuração iOS/macOS
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Configuração Linux
      const linuxSettings = LinuxInitializationSettings(
        defaultActionName: 'Open notification',
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
        linux: linuxSettings,
      );

      // Inicializar o plugin
      final result = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _initialized = result ?? false;

      // Solicitar permissões
      await _requestPermissions();

      if (kDebugMode) {
        print('NotificationService inicializado: $_initialized');
        print('Permissão concedida: $_permissionGranted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao inicializar NotificationService: $e');
      }
      _initialized = false;
    }
  }

  /// Solicitar permissões de notificação
  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android 13+ requer permissão runtime
      final androidImpl =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImpl != null) {
        _permissionGranted =
            await androidImpl.requestNotificationsPermission() ?? false;
      } else {
        _permissionGranted = true; // Versões antigas do Android
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      // iOS/macOS
      final iosImpl = _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      if (iosImpl != null) {
        _permissionGranted = await iosImpl.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
    } else {
      // Web e outras plataformas
      _permissionGranted = true;
    }
  }

  /// Callback quando notificação é tocada
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notificação tocada: ${response.payload}');
    }
    // Aqui você pode adicionar navegação ou outras ações
  }

  /// Mostra uma notificação de conclusão do Pomodoro
  Future<void> showPomodoroNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized || !_permissionGranted) {
      if (kDebugMode) {
        print('Notificações não disponíveis (init: $_initialized, perm: $_permissionGranted)');
      }
      return;
    }

    try {
      // Configuração Android
      const androidDetails = AndroidNotificationDetails(
        'pomodoro_channel', // ID do canal
        'Pomodoro Timer', // Nome do canal
        channelDescription: 'Notificações do timer Pomodoro',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: false, // Sem vibração conforme solicitado
        icon: '@mipmap/ic_launcher',
      );

      // Configuração iOS/macOS
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Configuração Linux
      const linuxDetails = LinuxNotificationDetails();

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
        linux: linuxDetails,
      );

      // Mostrar notificação
      await _notifications.show(
        0, // ID da notificação (0 = sempre sobrescreve a anterior)
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      if (kDebugMode) {
        print('Notificação enviada: $title - $body');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao mostrar notificação: $e');
      }
    }
  }

  /// Mostra uma notificação de alerta de tempo na tarefa (4+ pomodoros)
  Future<void> showTaskTimeAlert({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized || !_permissionGranted) {
      if (kDebugMode) {
        print('Notificações não disponíveis (init: $_initialized, perm: $_permissionGranted)');
      }
      return;
    }

    try {
      // Configuração Android - Canal diferente para alertas de tempo
      const androidDetails = AndroidNotificationDetails(
        'task_time_alert_channel', // ID do canal diferente
        'Alertas de Tempo', // Nome do canal
        channelDescription: 'Alertas quando você passa muito tempo em uma tarefa',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: false,
        icon: '@mipmap/ic_launcher',
      );

      // Configuração iOS/macOS
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Configuração Linux
      const linuxDetails = LinuxNotificationDetails();

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
        linux: linuxDetails,
      );

      // Mostrar notificação com ID diferente (1 = alerta de tempo)
      await _notifications.show(
        1,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      if (kDebugMode) {
        print('Alerta de tempo enviado: $title - $body');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao mostrar alerta de tempo: $e');
      }
    }
  }

  /// Cancela todas as notificações
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Verifica se as notificações estão disponíveis
  bool get isAvailable => _initialized && _permissionGranted;
}
