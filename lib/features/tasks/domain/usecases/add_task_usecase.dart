import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class AddTaskUseCase {
  final TaskRepository _repository;

  AddTaskUseCase(this._repository);

  Future<Task> call({
    required String title,
    required String description,
    required String userId,
    TaskStatus status = TaskStatus.todo,
  }) async {
    final newTask = Task(
      id: '',
      title: title,
      description: description,
      status: status,
    );
    return await _repository.addTask(newTask, userId);
  }
}
