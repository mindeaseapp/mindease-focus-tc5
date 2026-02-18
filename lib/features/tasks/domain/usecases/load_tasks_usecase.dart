import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class LoadTasksUseCase {
  final TaskRepository _repository;

  LoadTasksUseCase(this._repository);

  Future<List<Task>> call() async {
    return await _repository.getTasks();
  }
}
