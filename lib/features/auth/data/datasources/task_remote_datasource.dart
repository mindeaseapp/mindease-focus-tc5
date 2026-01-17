import 'package:supabase_flutter/supabase_flutter.dart';
// Importa a model original
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<Task>> getTasks();
  Future<Task> addTask(Task task, String userId);
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
  Future<void> updateTaskStatus(String id, TaskStatus status) async {
    final statusString = status.toString().split('.').last;
    
    await supabase.from('tasks').update({
      'status': statusString
    }).eq('id', id);
  }

  @override
  Future<void> deleteTask(String id) async {
    await supabase.from('tasks').delete().eq('id', id);
  }
}