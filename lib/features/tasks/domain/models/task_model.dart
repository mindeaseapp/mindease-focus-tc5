import 'package:mindease_focus/features/dashboard/presentation/pages/dashboard_styles.dart';

// ==============================
// 📦 TASK MODEL (Entidade Única)
// ==============================

enum TaskStatus {
  todo,
  inProgress,
  done,
}

extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.todo:
        return 'A Fazer';
      case TaskStatus.inProgress:
        return 'Em Andamento';
      case TaskStatus.done:
        return 'Concluído';
    }
  }

  String get dashboardLabel {
    switch (this) {
      case TaskStatus.todo:
        return 'pendente';
      case TaskStatus.inProgress:
        return 'em andamento';
      case TaskStatus.done:
        return 'concluída';
    }
  }

  DashboardTaskPillKind get dashboardPillKind {
    switch (this) {
      case TaskStatus.todo:
        return DashboardTaskPillKind.pending;
      case TaskStatus.inProgress:
        return DashboardTaskPillKind.inProgress;
      case TaskStatus.done:
        return DashboardTaskPillKind.done;
    }
  }
}

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final String? timeSpent; // Campo opcional (ainda não vem do banco)

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.timeSpent,
  });

  // ✅ CONVERTER DE SUPABASE (JSON) -> PARA TASK
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      // Converte a string 'todo' do banco para o enum TaskStatus.todo
      status: TaskStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TaskStatus.todo,
      ),
      timeSpent: null, 
    );
  }

  // ✅ CONVERTER DE TASK -> PARA SUPABASE (JSON)
  Map<String, dynamic> toJson({required String userId}) {
    return {
      'user_id': userId, // Vincula ao usuário logado
      'title': title,
      'description': description,
      // Salva no banco apenas a string: 'todo', 'inProgress' etc
      'status': status.toString().split('.').last,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    String? timeSpent,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      timeSpent: timeSpent ?? this.timeSpent,
    );
  }

  String get statusText => status.label;

  @override
  String toString() => 'Task(id: $id, title: $title, status: $status)';
}
// 🗑️ (Remova a lista initialTasks que existia aqui)