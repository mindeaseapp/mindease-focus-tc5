
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;
  late AddTaskUseCase useCase;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = AddTaskUseCase(mockRepository);
    registerFallbackValue(const Task(id: '', title: '', status: TaskStatus.todo));
  });

  const tUserId = 'user123';
  const tTitle = 'New Task';
  const tDescription = 'Description';
  
  final tTask = const Task(
    id: 'task-1',
    title: tTitle,
    description: tDescription,
    status: TaskStatus.todo,
  );

  test('should call addTask on repository', () async {
    when(() => mockRepository.addTask(any(), tUserId))
        .thenAnswer((_) async => tTask);

    final result = await useCase(
      title: tTitle, 
      description: tDescription, 
      userId: tUserId,
    );

    expect(result, tTask);
    verify(() => mockRepository.addTask(any(), tUserId)).called(1);
  });
}
