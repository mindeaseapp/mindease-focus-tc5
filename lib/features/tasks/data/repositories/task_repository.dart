import 'package:mindease_focus/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class TaskRepository {
  final TaskRemoteDataSource dataSource;

  TaskRepository(this.dataSource);

  Future<List<Task>> getTasks() async => dataSource.getTasks();

  Future<Task> addTask(Task task, String userId) async =>
      dataSource.addTask(task, userId);

  Future<Task> updateTask(
    String id, {
    required String title,
    required String description,
    required TaskStatus status,
  }) async {
    return dataSource.updateTask(
      id,
      title: title,
      description: description,
      status: status,
    );
  }

  Future<void> updateTaskStatus(String id, TaskStatus status) async =>
      dataSource.updateTaskStatus(id, status);

  Future<void> deleteTask(String id) async => dataSource.deleteTask(id);
}
