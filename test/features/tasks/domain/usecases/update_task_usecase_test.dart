
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;
  late UpdateTaskUseCase useCase;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = UpdateTaskUseCase(mockRepository);
  });

  const tTaskId = '1';
  const tTitle = 'Updated Task';
  const tDescription = 'Updated Description';
  const tStatus = TaskStatus.inProgress;

  final tTask = const Task(
    id: tTaskId,
    title: tTitle,
    description: tDescription,
    status: tStatus,
  );

  group('call', () {
    test('should modify task via repository', () async {
      when(() => mockRepository.updateTask(
            tTaskId,
            title: tTitle,
            description: tDescription,
            status: tStatus,
          )).thenAnswer((_) async => tTask);

      final result = await useCase(
        tTaskId,
        title: tTitle,
        description: tDescription,
        status: tStatus,
      );

      expect(result, tTask);
      verify(() => mockRepository.updateTask(
            tTaskId,
            title: tTitle,
            description: tDescription,
            status: tStatus,
          )).called(1);
    });
  });

  group('updateStatus', () {
    test('should update status via repository', () async {
      when(() => mockRepository.updateTaskStatus(tTaskId, tStatus))
          .thenAnswer((_) async => Future.value());

      await useCase.updateStatus(tTaskId, tStatus);

      verify(() => mockRepository.updateTaskStatus(tTaskId, tStatus)).called(1);
    });
  });
}
