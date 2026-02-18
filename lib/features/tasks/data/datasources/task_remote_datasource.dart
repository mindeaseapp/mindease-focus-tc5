import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<Task>> getTasks();
  Future<Task> addTask(Task task, String userId);
  Future<Task> updateTask(
    String id, {
    required String title,
    required String description,
    required TaskStatus status,
  });
  Future<void> updateTaskStatus(String id, TaskStatus status);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final SupabaseClient supabase;

  TaskRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<Task>> getTasks() async {
    final response = await supabase
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => Task.fromJson(json)).toList();
  }

  @override
  Future<Task> addTask(Task task, String userId) async {
    final response = await supabase
        .from('tasks')
        .insert(task.toJson(userId: userId))
        .select()
        .single();

    return Task.fromJson(response);
  }

  @override
  Future<Task> updateTask(
    String id, {
    required String title,
    required String description,
    required TaskStatus status,
  }) async {
    final statusString = status.toString().split('.').last;

    final response = await supabase
        .from('tasks')
        .update({
          'title': title,
          'description': description.trim().isEmpty ? null : description.trim(),
          'status': statusString,
        })
        .eq('id', id)
        .select()
        .single();

    return Task.fromJson(response);
  }

  @override
  Future<void> updateTaskStatus(String id, TaskStatus status) async {
    final statusString = status.toString().split('.').last;

    await supabase.from('tasks').update({
      'status': statusString,
    }).eq('id', id);
  }

  @override
  Future<void> deleteTask(String id) async {
    await supabase.from('tasks').delete().eq('id', id);
  }
}
