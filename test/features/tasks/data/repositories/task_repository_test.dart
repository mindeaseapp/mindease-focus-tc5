
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';
import 'package:mindease_focus/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

void main() {
  late MockTaskRemoteDataSource mockDataSource;
  late TaskRepository repository;

  setUp(() {
    mockDataSource = MockTaskRemoteDataSource();
    repository = TaskRepository(mockDataSource);
  });

  final tTask = const Task(id: '1', title: 'Task 1', status: TaskStatus.todo);
  final tTasks = [tTask];
  const tUserId = 'user123';

  group('getTasks', () {
    test('should return tasks from datasource', () async {
      when(() => mockDataSource.getTasks()).thenAnswer((_) async => tTasks);
      final result = await repository.getTasks();
      expect(result, tTasks);
      verify(() => mockDataSource.getTasks()).called(1);
    });
  });

  group('addTask', () {
    test('should add task via datasource', () async {
      when(() => mockDataSource.addTask(tTask, tUserId)).thenAnswer((_) async => tTask);
      final result = await repository.addTask(tTask, tUserId);
      expect(result, tTask);
      verify(() => mockDataSource.addTask(tTask, tUserId)).called(1);
    });
  });

  group('updateTask', () {
    test('should update task via datasource', () async {
      when(() => mockDataSource.updateTask(
            '1',
            title: 'Updated',
            description: 'Desc',
            status: TaskStatus.inProgress,
          )).thenAnswer((_) async => tTask);

      await repository.updateTask(
        '1',
        title: 'Updated',
        description: 'Desc',
        status: TaskStatus.inProgress,
      );

      verify(() => mockDataSource.updateTask(
            '1',
            title: 'Updated',
            description: 'Desc',
            status: TaskStatus.inProgress,
          )).called(1);
    });
  });

  group('deleteTask', () {
    test('should delete task via datasource', () async {
      when(() => mockDataSource.deleteTask('1')).thenAnswer((_) async => Future.value());
      await repository.deleteTask('1');
      verify(() => mockDataSource.deleteTask('1')).called(1);
    });
  });
}
