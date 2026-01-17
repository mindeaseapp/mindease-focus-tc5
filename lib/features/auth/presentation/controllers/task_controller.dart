import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/features/auth/data/repositories/task_repository.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';

class TaskController extends ChangeNotifier {
  final TaskRepository repository;
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  TaskController({required this.repository});

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Getters filtrados para as colunas do Kanban
  List<Task> get todoTasks => _tasks.where((t) => t.status == TaskStatus.todo).toList();
  List<Task> get inProgressTasks => _tasks.where((t) => t.status == TaskStatus.inProgress).toList();
  List<Task> get doneTasks => _tasks.where((t) => t.status == TaskStatus.done).toList();

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await repository.getTasks();
    } catch (e) {
      _error = 'Erro ao carregar tarefas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title, String description, {TaskStatus status = TaskStatus.todo}) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      
      final newTask = Task(
        id: '', // O ID vem do banco
        title: title,
        description: description,
        status: status, // ✅ AGORA USA O STATUS RECEBIDO (ou 'todo' se não vier nada)
      );

      final createdTask = await repository.addTask(newTask, userId);
      _tasks.insert(0, createdTask);
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao criar tarefa';
      notifyListeners();
    }
  }

  Future<void> updateStatus(String taskId, TaskStatus newStatus) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final oldTask = _tasks[index];
    // Atualiza a UI imediatamente (Otimistic Update)
    _tasks[index] = oldTask.copyWith(status: newStatus);
    notifyListeners();

    try {
      await repository.updateTaskStatus(taskId, newStatus);
    } catch (e) {
      // Reverte em caso de erro
      _tasks[index] = oldTask;
      _error = 'Erro ao mover tarefa';
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    final taskBackup = _tasks.firstWhere((t) => t.id == taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();

    try {
      await repository.deleteTask(taskId);
    } catch (e) {
      _tasks.add(taskBackup);
      _error = 'Erro ao deletar tarefa';
      notifyListeners();
    }
  }
}