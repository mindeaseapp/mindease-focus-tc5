import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class UpdateTaskUseCase {
  final TaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<Task> call(
    String taskId, {
    required String title,
    required String description,
    required TaskStatus status,
  }) async {
    return await _repository.updateTask(
      taskId,
      title: title,
      description: description,
      status: status,
    );
  }

  Future<void> updateStatus(String taskId, TaskStatus status) async {
    await _repository.updateTaskStatus(taskId, status);
  }
}
