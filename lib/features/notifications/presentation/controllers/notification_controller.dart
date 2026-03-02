import 'package:flutter/foundation.dart';
import 'package:mindease_focus/features/notifications/domain/models/notification_model.dart';

/// Gerencia o histórico de notificações in-app (sininho) e o contador de
/// não-lidas. Notificações push do sistema são responsabilidade do
/// [NotificationService].
class NotificationController extends ChangeNotifier {
  static int _idCounter = 0;

  final List<NotificationModel> _notifications = [];

  /// Lista imutável — clientes não podem modificar diretamente.
  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // ── Adicionar ──────────────────────────────────────────────────────────────

  /// Insere uma nova notificação no topo da lista.
  void addNotification({required String title, required String body}) {
    final notification = NotificationModel(
      id: '${DateTime.now().millisecondsSinceEpoch}_${++_idCounter}',
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // ── Leitura ────────────────────────────────────────────────────────────────

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  // ── Limpeza ────────────────────────────────────────────────────────────────

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
