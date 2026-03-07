
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

void main() {
  late DashboardController controller;

  setUp(() {
    controller = DashboardController();
  });

  group('DashboardController', () {
    test('initial state should be correct', () {
      expect(controller.welcomeHandled, false);
    });

    test('markWelcomeHandled should update state', () {
      controller.markWelcomeHandled();
      expect(controller.welcomeHandled, true);

      bool notified = false;
      controller.addListener(() => notified = true);
      controller.markWelcomeHandled();
      expect(notified, false);
    });

    test('getMetrics should return correct metrics based on tasks', () {
      final tasks = [
        Task(
          id: '1',
          title: 'Task 1',
          description: '',
          status: TaskStatus.done,
        ),
        Task(
          id: '2',
          title: 'Task 2',
          description: '',
          status: TaskStatus.todo,
        ),
      ];

      final metrics = controller.getMetrics(tasks);

      expect(metrics.length, 3);
      expect(metrics[0].title, 'Pendentes');
      expect(metrics[0].value, '1'); 
      
      expect(metrics[1].title, 'Concluídas');
      expect(metrics[1].value, '1'); 

      expect(metrics[2].title, 'Motivação');
    });
  });
}
