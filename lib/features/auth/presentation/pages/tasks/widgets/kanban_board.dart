import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/kanban_column.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/new_task_dialog.dart';

class KanbanBoard extends StatefulWidget {
  const KanbanBoard({super.key});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  
  final List<Map<String, dynamic>> _columns = [
    {
      'id': TaskStatus.todo,
      'title': 'A Fazer',
      'icon': Icons.circle_outlined,
      'color': Colors.grey.shade600,
      'bgColor': Colors.grey.shade50,
    },
    {
      'id': TaskStatus.inProgress,
      'title': 'Em Andamento',
      'icon': Icons.pending_outlined,
      'color': Colors.blue.shade600,
      'bgColor': Colors.blue.shade50,
    },
    {
      'id': TaskStatus.done,
      'title': 'Concluído',
      'icon': Icons.check_circle_outline,
      'color': Colors.green.shade600,
      'bgColor': Colors.green.shade50,
    },
  ];

  void _handleAddTask(String title, String description, TaskStatus status) {
    context.read<TaskController>().addTask(
      title, 
      description, 
      status: status, 
    ); 
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Salvando tarefa em "${_getStatusText(status)}"...'),
        backgroundColor: Colors.blue.shade600,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleDeleteTask(String taskId) {
    context.read<TaskController>().deleteTask(taskId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tarefa removida'),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleTaskMoved(Task task, TaskStatus newStatus) {
    context.read<TaskController>().updateStatus(task.id, newStatus);
  }

  // Helper para obter texto do status
  String _getStatusText(TaskStatus status) {
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
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();
    final tasks = taskController.tasks; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        Expanded(
          child: _buildColumns(tasks),
        ),
      ],
    );
  }

  // === HEADER ===

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildHeaderMobile();
        }
        return _buildHeaderDesktop();
      },
    );
  }

  Widget _buildHeaderMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderTitle(),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: _buildAddTaskButton()),
      ],
    );
  }

  Widget _buildHeaderDesktop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeaderTitle(),
        _buildAddTaskButton(),
      ],
    );
  }

  Widget _buildHeaderTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quadro Kanban',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Organize suas tarefas de forma visual',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildAddTaskButton() {
    return ElevatedButton.icon(
      onPressed: () {
        showNewTaskDialog(
          context: context,
          onAddTask: _handleAddTask,
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Nova Tarefa'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  // === COLUNAS ===

  Widget _buildColumns(List<Task> tasks) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return _buildMobileLayout(tasks);
        }
        return _buildDesktopLayout(tasks);
      },
    );
  }

  // ✅ NOVO: Layout Desktop com Linhas Verticais
  Widget _buildDesktopLayout(List<Task> tasks) {
    List<Widget> children = [];

    for (int i = 0; i < _columns.length; i++) {
      final columnData = _columns[i];

      // Adiciona a coluna
      children.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildColumn(columnData, tasks),
          ),
        ),
      );

      // Adiciona o divisor se não for a última
      if (i < _columns.length - 1) {
        children.add(
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey.shade300,
            indent: 16,
            endIndent: 16,
          ),
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildMobileLayout(List<Task> tasks) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ..._columns.map((column) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 300, 
                child: _buildColumn(column, tasks),
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '💡 Dica: Pressione e segure uma tarefa para arrastá-la',
                    style: TextStyle(fontSize: 13, color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(Map<String, dynamic> column, List<Task> allTasks) {
    return KanbanColumn(
      status: column['id'] as TaskStatus,
      title: column['title'] as String,
      icon: column['icon'] as IconData,
      color: column['color'] as Color,
      backgroundColor: column['bgColor'] as Color,
      allTasks: allTasks,
      onTaskMoved: _handleTaskMoved,
      onTaskDeleted: _handleDeleteTask,
    );
  }
}