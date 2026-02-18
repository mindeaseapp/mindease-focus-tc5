import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository _repository;

  DeleteTaskUseCase(this._repository);

  Future<void> call(String taskId) async {
    await _repository.deleteTask(taskId);
  }
}
