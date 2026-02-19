import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/features/auth/data/repositories/task_repository.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';
import 'package:mindease_focus/shared/services/pomodoro_alert_service.dart';

class TaskController extends ChangeNotifier {
  final TaskRepository repository;
  final PomodoroAlertService? pomodoroAlertService;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  TaskController({
    required this.repository,
    this.pomodoroAlertService,
  });

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Task> get todoTasks =>
      _tasks.where((t) => t.status == TaskStatus.todo).toList();
  List<Task> get inProgressTasks =>
      _tasks.where((t) => t.status == TaskStatus.inProgress).toList();
  List<Task> get doneTasks =>
      _tasks.where((t) => t.status == TaskStatus.done).toList();

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

  Future<void> addTask(
    String title,
    String description, {
    TaskStatus status = TaskStatus.todo,
  }) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      final newTask = Task(
        id: '',
        title: title,
        description: description,
        status: status,
      );

      final createdTask = await repository.addTask(newTask, userId);
      _tasks.insert(0, createdTask);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao criar tarefa: $e';
      notifyListeners();
    }
  }

  /// ✅ Edita título/descrição/status e retorna sucesso/erro
  Future<bool> updateTask(
    String taskId, {
    required String title,
    required String description,
    required TaskStatus status,
  }) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return false;

    final oldTask = _tasks[index];

    // Optimistic update (UI muda na hora)
    _tasks[index] = oldTask.copyWith(
      title: title,
      description: description,
      status: status,
    );
    _error = null;
    notifyListeners();

    try {
      // ✅ pega o retorno do banco (garante consistência)
      final updated = await repository.updateTask(
        taskId,
        title: title,
        description: description,
        status: status,
      );

      _tasks[index] = updated;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      // rollback
      _tasks[index] = oldTask;
      _error = 'Erro ao editar tarefa: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> updateStatus(String taskId, TaskStatus newStatus) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final oldTask = _tasks[index];

    _tasks[index] = oldTask.copyWith(status: newStatus);
    _error = null;
    notifyListeners();

    // ✅ Se moveu para "In Progress", resetar contador de pomodoros
    if (newStatus == TaskStatus.inProgress && pomodoroAlertService != null) {
      pomodoroAlertService!.reset();
      if (kDebugMode) {
        print('TaskController: Tarefa movida para In Progress - Contador de pomodoros resetado');
      }
    }

    try {
      await repository.updateTaskStatus(taskId, newStatus);
    } catch (e) {
      _tasks[index] = oldTask;
      _error = 'Erro ao mover tarefa: $e';
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    final taskBackup = _tasks.firstWhere((t) => t.id == taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    _error = null;
    notifyListeners();

    try {
      await repository.deleteTask(taskId);
    } catch (e) {
      _tasks.add(taskBackup);
      _error = 'Erro ao deletar tarefa: $e';
      notifyListeners();
    }
  }
}
