import 'package:flutter/foundation.dart';
import 'package:mindease_focus/features/notifications/domain/models/notification_model.dart';

class NotificationController extends ChangeNotifier {
  static int _idCounter = 0;

  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

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

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
