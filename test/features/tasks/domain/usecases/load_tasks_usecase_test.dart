
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/load_tasks_usecase.dart';
import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;
  late LoadTasksUseCase useCase;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = LoadTasksUseCase(mockRepository);
  });

  final tTasks = [
    const Task(id: '1', title: 'Task 1', status: TaskStatus.todo),
    const Task(id: '2', title: 'Task 2', status: TaskStatus.done),
  ];

  test('should return list of tasks from repository', () async {
    when(() => mockRepository.getTasks()).thenAnswer((_) async => tTasks);

    final result = await useCase();

    expect(result, tTasks);
    verify(() => mockRepository.getTasks()).called(1);
  });
}
