// ==============================
// 📦 TASK MODEL
// ==============================

enum TaskStatus {
  todo,
  inProgress,
  done,
}

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final String? timeSpent;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.timeSpent,
  });

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

  String get statusText {
    switch (status) {
      case TaskStatus.todo:
        return 'A Fazer';
      case TaskStatus.inProgress:
        return 'Em Andamento';
      case TaskStatus.done:
        return 'Concluído';
    }
  }

  @override
  String toString() => 'Task(id: $id, title: $title, status: $status)';
}

// ✅ Agora tudo const -> some os 4 warnings prefer_const_constructors
const List<Task> initialTasks = [
  Task(
    id: '1',
    title: 'Estudar React Hooks',
    description: 'Revisar useState, useEffect e useContext',
    status: TaskStatus.inProgress,
    timeSpent: '2h',
  ),
  Task(
    id: '2',
    title: 'Fazer exercícios de algoritmos',
    description: 'Resolver 5 problemas no LeetCode',
    status: TaskStatus.todo,
  ),
  Task(
    id: '3',
    title: 'Revisar projeto final',
    description: 'Preparar apresentação para a aula',
    status: TaskStatus.inProgress,
    timeSpent: '1h 30m',
  ),
  Task(
    id: '4',
    title: 'Ler capítulo 5 - Algoritmos',
    status: TaskStatus.done,
    timeSpent: '45m',
  ),
];
