import 'package:mindease_focus/features/auth/data/datasources/task_remote_datasource.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';

class TaskRepository {
  final TaskRemoteDataSource dataSource;

  TaskRepository(this.dataSource);

  Future<List<Task>> getTasks() async {
    return await dataSource.getTasks();
  }

  Future<Task> addTask(Task task, String userId) async {
    return await dataSource.addTask(task, userId);
  }

  Future<void> updateTaskStatus(String id, TaskStatus status) async {
    return await dataSource.updateTaskStatus(id, status);
  }

  Future<void> deleteTask(String id) async {
    return await dataSource.deleteTask(id);
  }
}