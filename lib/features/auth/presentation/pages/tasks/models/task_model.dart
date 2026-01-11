// ==============================
// 📦 TASK MODEL
// ==============================
// Este arquivo define a estrutura de dados de uma Tarefa (Task)
// Similar ao TypeScript interface, mas é uma classe Dart completa

/// Enum que define os possíveis status de uma tarefa
/// Em React/TS seria: type TaskStatus = 'todo' | 'in-progress' | 'done'
enum TaskStatus {
  todo,        // A Fazer
  inProgress,  // Em Andamento
  done,        // Concluído
}

/// Classe que representa uma Tarefa no Kanban
/// 
/// Em React, você usaria uma interface TypeScript:
/// interface Task { id: string; title: string; ... }
/// 
/// No Flutter, usamos classes com campos final (imutáveis)
class Task {
  /// ID único da tarefa (gerado com timestamp ou UUID)
  final String id;
  
  /// Título da tarefa (obrigatório)
  final String title;
  
  /// Descrição detalhada (opcional)
  final String? description;  // O "?" indica que pode ser null
  
  /// Status atual da tarefa (enum)
  final TaskStatus status;
  
  /// Tempo gasto na tarefa (formato: "2h 30m")
  final String? timeSpent;

  /// Constructor - Similar ao constructor do TypeScript
  /// Usa "named parameters" (entre chaves) para legibilidade
  /// O "required" indica parâmetros obrigatórios
  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.timeSpent,
  });

  /// Método copyWith - MUITO IMPORTANTE no Flutter!
  /// 
  /// Como os campos são "final" (imutáveis), não podemos fazer:
  /// task.status = TaskStatus.done; ❌
  /// 
  /// Em vez disso, criamos uma NOVA instância com valores atualizados:
  /// final updatedTask = task.copyWith(status: TaskStatus.done); ✅
  /// 
  /// Isso é parecido com o spread operator do React:
  /// const updatedTask = { ...task, status: 'done' }
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    String? timeSpent,
  }) {
    return Task(
      id: id ?? this.id,                    // Se id for null, usa o atual
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      timeSpent: timeSpent ?? this.timeSpent,
    );
  }

  /// Método helper para obter o texto do status em português
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

  /// Método para converter o enum em string (útil para debug)
  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status)';
  }
}

/// Lista de tarefas iniciais (demo)
/// Similar ao "initialTasks" do React
final List<Task> initialTasks = [
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
