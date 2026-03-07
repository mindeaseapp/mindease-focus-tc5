import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/notifications/domain/models/notification_model.dart';
import 'package:mindease_focus/features/notifications/presentation/controllers/notification_controller.dart';

void main() {
  late NotificationController controller;

  setUp(() {
    controller = NotificationController();
  });

  group('NotificationController', () {
    group('estado inicial', () {
      test('lista começa vazia', () {
        expect(controller.notifications, isEmpty);
      });

      test('unreadCount começa em zero', () {
        expect(controller.unreadCount, 0);
      });
    });

    group('addNotification', () {
      test('adiciona a notificação na lista', () {
        controller.addNotification(title: 'Foco concluído', body: 'Descansar!');
        expect(controller.notifications.length, 1);
      });

      test('notificação criada tem campos corretos', () {
        controller.addNotification(title: 'Título', body: 'Corpo');
        final n = controller.notifications.first;
        expect(n.title, 'Título');
        expect(n.body, 'Corpo');
        expect(n.isRead, false);
      });

      test('insere na primeira posição (mais recente primeiro)', () {
        controller.addNotification(title: 'Primeira', body: '');
        controller.addNotification(title: 'Segunda', body: '');
        expect(controller.notifications.first.title, 'Segunda');
      });

      test('incrementa unreadCount a cada notificação', () {
        controller.addNotification(title: 'A', body: '');
        controller.addNotification(title: 'B', body: '');
        expect(controller.unreadCount, 2);
      });

      test('notifica listeners ao adicionar', () {
        var called = false;
        controller.addListener(() => called = true);
        controller.addNotification(title: 'x', body: '');
        expect(called, true);
      });
    });

    group('markAsRead', () {
      test('marca notificação como lida', () {
        controller.addNotification(title: 'A', body: '');
        final id = controller.notifications.first.id;

        controller.markAsRead(id);

        expect(controller.notifications.first.isRead, true);
        expect(controller.unreadCount, 0);
      });

      test('não altera outras notificações', () {
        controller.addNotification(title: 'A', body: '');
        controller.addNotification(title: 'B', body: '');
        final idA = controller.notifications.last.id;

        controller.markAsRead(idA);

        expect(controller.notifications.last.isRead, true);
        expect(controller.notifications.first.isRead, false); 
        expect(controller.unreadCount, 1);
      });

      test('id inexistente não lança erro', () {
        expect(() => controller.markAsRead('id_inexistente'), returnsNormally);
      });

      test('notifica listeners ao marcar como lida', () {
        controller.addNotification(title: 'x', body: '');
        final id = controller.notifications.first.id;
        var callCount = 0;
        controller.addListener(() => callCount++);

        controller.markAsRead(id);

        expect(callCount, 1);
      });
    });

    group('markAllAsRead', () {
      test('marca todas como lidas e unreadCount volta a zero', () {
        controller.addNotification(title: 'A', body: '');
        controller.addNotification(title: 'B', body: '');
        controller.addNotification(title: 'C', body: '');

        controller.markAllAsRead();

        expect(controller.unreadCount, 0);
        expect(controller.notifications.every((n) => n.isRead), true);
      });

      test('funciona com lista vazia sem erro', () {
        expect(() => controller.markAllAsRead(), returnsNormally);
      });

      test('notifica listeners', () {
        controller.addNotification(title: 'x', body: '');
        var called = false;
        controller.addListener(() => called = true);

        controller.markAllAsRead();

        expect(called, true);
      });
    });

    group('clearAll', () {
      test('esvazia a lista completamente', () {
        controller.addNotification(title: 'A', body: '');
        controller.addNotification(title: 'B', body: '');

        controller.clearAll();

        expect(controller.notifications, isEmpty);
        expect(controller.unreadCount, 0);
      });

      test('funciona com lista já vazia', () {
        expect(() => controller.clearAll(), returnsNormally);
      });

      test('notifica listeners', () {
        controller.addNotification(title: 'x', body: '');
        var called = false;
        controller.addListener(() => called = true);

        controller.clearAll();

        expect(called, true);
      });
    });

    group('imutabilidade da lista', () {
      test('notifications retorna lista imutável', () {
        controller.addNotification(title: 'A', body: '');
        final list = controller.notifications;
        final fakeNotification = NotificationModel(
          id: 'fake',
          title: 'fake',
          body: 'fake',
          timestamp: DateTime.now(),
        );
        expect(
          () => (list as dynamic).add(fakeNotification),
          throwsUnsupportedError,
        );
      });
    });
  });
}
