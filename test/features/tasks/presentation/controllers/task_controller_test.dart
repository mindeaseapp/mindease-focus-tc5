
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/load_tasks_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class MockLoadTasksUseCase extends Mock implements LoadTasksUseCase {}
class MockAddTaskUseCase extends Mock implements AddTaskUseCase {}
class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}
class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}

void main() {
  late TaskController controller;
  late MockLoadTasksUseCase mockLoadTasksUseCase;
  late MockAddTaskUseCase mockAddTaskUseCase;
  late MockUpdateTaskUseCase mockUpdateTaskUseCase;
  late MockDeleteTaskUseCase mockDeleteTaskUseCase;

  setUpAll(() {
    registerFallbackValue(TaskStatus.todo);
  });

  setUp(() {
    mockLoadTasksUseCase = MockLoadTasksUseCase();
    mockAddTaskUseCase = MockAddTaskUseCase();
    mockUpdateTaskUseCase = MockUpdateTaskUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();

    controller = TaskController(
      loadTasksUseCase: mockLoadTasksUseCase,
      addTaskUseCase: mockAddTaskUseCase,
      updateTaskUseCase: mockUpdateTaskUseCase,
      deleteTaskUseCase: mockDeleteTaskUseCase,
    );
  });

  group('TaskController', () {
    test('initial state should be empty', () {
      expect(controller.tasks, isEmpty);
      expect(controller.isLoading, false);
      expect(controller.error, null);
    });

    test('loadTasks success', () async {
      final tasks = [
        Task(id: '1', title: 'Task 1', description: '', status: TaskStatus.todo),
      ];
      when(() => mockLoadTasksUseCase()).thenAnswer((_) async => tasks);

      final future = controller.loadTasks();

      expect(controller.isLoading, true);
      await future;
      expect(controller.isLoading, false);
      expect(controller.tasks, tasks);
    });

    test('loadTasks failure', () async {
      when(() => mockLoadTasksUseCase()).thenAnswer((_) async => throw Exception('Load failed'));

      final future = controller.loadTasks();

      expect(controller.isLoading, true);
      await future;
      expect(controller.isLoading, false);
      expect(controller.error, contains('Load failed'));
    });

    test('addTask success', () async {
      final task = Task(id: '1', title: 'Task 1', description: '', status: TaskStatus.todo);
      when(() => mockAddTaskUseCase(
        title: any(named: 'title'),
        description: any(named: 'description'),
        userId: any(named: 'userId'),
        status: any(named: 'status'),
      )).thenAnswer((_) async => task);

      await controller.addTask('Task 1', '', 'user1');

      expect(controller.tasks, contains(task));
      expect(controller.error, null);
    });
    
    // Additional tests for update and delete can be added following similar pattern
  });
}
