import 'package:flutter/material.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';
import 'package:mindease_focus/features/notifications/data/services/notification_service.dart';
import 'package:mindease_focus/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/load_tasks_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/delete_task_usecase.dart';

class TaskController extends ChangeNotifier {
  final LoadTasksUseCase _loadTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  TaskController({
    required LoadTasksUseCase loadTasksUseCase,
    required AddTaskUseCase addTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
  })  : _loadTasksUseCase = loadTasksUseCase,
        _addTaskUseCase = addTaskUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase;

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
      _tasks = await _loadTasksUseCase();
    } catch (e) {
      _error = 'Erro ao carregar tarefas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(
    String title,
    String description,
    String userId, {
    TaskStatus status = TaskStatus.todo,
  }) async {
    try {
      final createdTask = await _addTaskUseCase(
        title: title,
        description: description,
        userId: userId,
        status: status,
      );
      _tasks.insert(0, createdTask);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao criar tarefa: $e';
      notifyListeners();
    }
  }

  Future<bool> updateTask(
    String taskId, {
    required String title,
    required String description,
    required TaskStatus status,
  }) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return false;

    final oldTask = _tasks[index];

    // Optimistic update
    _tasks[index] = oldTask.copyWith(
      title: title,
      description: description,
      status: status,
    );
    _error = null;
    notifyListeners();

    try {
      final updated = await _updateTaskUseCase(
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

    try {
      await _updateTaskUseCase.updateStatus(taskId, newStatus);
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
      await _deleteTaskUseCase(taskId);
    } catch (e) {
      _tasks.add(taskBackup);
      _error = 'Erro ao deletar tarefa: $e';
      notifyListeners();
    }
  }
  Future<void> incrementPomodoroCount(
    String taskId, {
    NotificationController? notificationController,
    bool taskTimeAlertEnabled = true,
    bool pushNotificationsEnabled = false,
  }) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final task = _tasks[index];
    final updatedTask = task.copyWith(
      pomodoroCount: task.pomodoroCount + 1,
    );

    _tasks[index] = updatedTask;
    notifyListeners();

    // Lógica de alerta: a cada 4 pomodoros (exemplo)
    if (taskTimeAlertEnabled && updatedTask.pomodoroCount % 4 == 0) {
      final title = '🎯 Meta alcançada!';
      final body =
          'Você completou ${updatedTask.pomodoroCount} pomodoros na tarefa: ${task.title}.';

      // Sininho in-app
      notificationController?.addNotification(title: title, body: body);

      // Push do sistema (conforme regra: Push depende de Alerta ON)
      if (pushNotificationsEnabled) {
        // ignore: unawaited_futures
        NotificationService()
            .showNotification(
          id: 3,
          title: title,
          body: body,
        )
            .catchError((_) {
          // Silencia erros de plataforma em testes
        });
      }
    }

    try {
      await _updateTaskUseCase(
        taskId,
        title: updatedTask.title,
        description: updatedTask.description ?? '',
        status: updatedTask.status,
        pomodoroCount: updatedTask.pomodoroCount,
      );
    } catch (e) {
      _error = 'Erro ao atualizar contagem: $e';
      notifyListeners();
    }
  }
}
