import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/kanban_column.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/new_task_dialog.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/kanban_board_styles.dart';

class KanbanBoard extends StatefulWidget {
  const KanbanBoard({super.key});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  final List<Map<String, dynamic>> _columns = KanbanBoardStyles.columns;

  void _handleAddTask(String title, String description, TaskStatus status) {
    context.read<TaskController>().addTask(
          title,
          description,
          status: status,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Salvando tarefa em "${_getStatusText(status)}"...'),
        backgroundColor: KanbanBoardStyles.savingSnackBg(),
        duration: KanbanBoardStyles.snackDuration,
      ),
    );
  }

  void _handleDeleteTask(String taskId) {
    context.read<TaskController>().deleteTask(taskId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tarefa removida'),
        backgroundColor: KanbanBoardStyles.deleteSnackBg(),
        duration: KanbanBoardStyles.snackDuration,
      ),
    );
  }

  void _handleTaskMoved(Task task, TaskStatus newStatus) {
    context.read<TaskController>().updateStatus(task.id, newStatus);
  }

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
        KanbanBoardStyles.gap24,
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
        if (constraints.maxWidth < KanbanBoardStyles.headerMobileBreakpoint) {
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
        KanbanBoardStyles.gap16,
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
          style: KanbanBoardStyles.headerTitle,
        ),
        KanbanBoardStyles.gap4h,
        Text(
          'Organize suas tarefas de forma visual',
          style: KanbanBoardStyles.headerSubtitle(),
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
      style: KanbanBoardStyles.addTaskButtonStyle(),
    );
  }

  // === COLUNAS ===

  Widget _buildColumns(List<Task> tasks) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < KanbanBoardStyles.columnsMobileBreakpoint) {
          return _buildMobileLayout(tasks);
        }
        return _buildDesktopLayout(tasks);
      },
    );
  }

  Widget _buildDesktopLayout(List<Task> tasks) {
    final List<Widget> children = [];

    for (int i = 0; i < _columns.length; i++) {
      final columnData = _columns[i];

      children.add(
        Expanded(
          child: Padding(
            padding: KanbanBoardStyles.desktopColumnPadding,
            child: _buildColumn(columnData, tasks),
          ),
        ),
      );

      if (i < _columns.length - 1) {
        children.add(
          VerticalDivider(
            width: KanbanBoardStyles.dividerWidth,
            thickness: KanbanBoardStyles.dividerThickness,
            color: KanbanBoardStyles.dividerColor(),
            indent: KanbanBoardStyles.dividerIndent,
            endIndent: KanbanBoardStyles.dividerEndIndent,
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
              padding: KanbanBoardStyles.mobileColumnBottomPadding,
              child: SizedBox(
                height: KanbanBoardStyles.mobileColumnHeight,
                child: _buildColumn(column, tasks),
              ),
            );
          }),
          Container(
            padding: KanbanBoardStyles.tipPadding,
            margin: KanbanBoardStyles.tipMargin,
            decoration: BoxDecoration(
              color: KanbanBoardStyles.tipBg(),
              border: Border.all(color: KanbanBoardStyles.tipBorder()),
              borderRadius: KanbanBoardStyles.tipRadius(),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: KanbanBoardStyles.tipIconColor()),
                KanbanBoardStyles.gap12w,
                Expanded(
                  child: Text(
                    '💡 Dica: Pressione e segure uma tarefa para arrastá-la',
                    style: KanbanBoardStyles.tipTextStyle(),
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
