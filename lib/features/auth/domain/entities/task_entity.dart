enum TaskStatus { todo, inProgress, done }

class TaskEntity {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final DateTime createdAt;

  TaskEntity({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
  });
}