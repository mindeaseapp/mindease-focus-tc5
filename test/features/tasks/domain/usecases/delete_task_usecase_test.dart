
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;
  late DeleteTaskUseCase useCase;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = DeleteTaskUseCase(mockRepository);
  });

  const tTaskId = '1';

  test('should delete task via repository', () async {
    when(() => mockRepository.deleteTask(tTaskId))
        .thenAnswer((_) async => Future.value());

    await useCase(tTaskId);

    verify(() => mockRepository.deleteTask(tTaskId)).called(1);
  });
}
