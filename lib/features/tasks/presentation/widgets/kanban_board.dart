import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';
import 'package:mindease_focus/features/tasks/presentation/widgets/kanban_column.dart';
import 'package:mindease_focus/features/tasks/presentation/widgets/new_task_dialog.dart';
import 'package:mindease_focus/features/tasks/presentation/widgets/edit_task_dialog.dart';
import 'package:mindease_focus/features/tasks/presentation/widgets/kanban_board_styles.dart';

class KanbanBoard extends StatefulWidget {
  final bool highContrast;
  final bool hideDistractions;

  const KanbanBoard({
    super.key,
    this.highContrast = false,
    this.hideDistractions = false,
  });

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  void _handleAddTask(String title, String description, TaskStatus status) {
    final userId = context.read<AuthController>().user.id;
    context.read<TaskController>().addTask(title, description, userId, status: status);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Salvando tarefa em "${status.label}"...'),
        backgroundColor: KanbanBoardStyles.savingSnackBg(context),
        duration: KanbanBoardStyles.snackDuration,
      ),
    );
  }

  void _handleDeleteTask(String taskId) {
    context.read<TaskController>().deleteTask(taskId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tarefa removida'),
        backgroundColor: KanbanBoardStyles.deleteSnackBg(context),
        duration: KanbanBoardStyles.snackDuration,
      ),
    );
  }

  void _handleTaskMoved(Task task, TaskStatus newStatus) {
    context.read<TaskController>().updateStatus(task.id, newStatus);
  }

  Future<void> _handleEditTask(Task task) async {
    final controller = context.read<TaskController>();

    final saved = await showEditTaskDialog(
      context: context,
      task: task,
      onSave: (title, description, status) async {
        final ok = await controller.updateTask(
          task.id,
          title: title,
          description: description,
          status: status,
        );
        if (!ok) {
          throw Exception(controller.error ?? 'Erro ao editar tarefa');
        }
      },
    );

    if (!mounted) return;

    if (saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tarefa atualizada ✅'),
          backgroundColor: KanbanBoardStyles.savingSnackBg(context),
          duration: KanbanBoardStyles.snackDuration,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();
    final tasks = taskController.tasks;
    final columns = KanbanBoardStyles.columns(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        KanbanBoardStyles.gap24,
        Expanded(child: _buildColumns(context, tasks, columns)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < KanbanBoardStyles.headerMobileBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderTitle(context),
              KanbanBoardStyles.gap16,
              SizedBox(width: double.infinity, child: _buildAddTaskButton(context)),
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeaderTitle(context),
            _buildAddTaskButton(context),
          ],
        );
      },
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quadro Kanban', style: KanbanBoardStyles.headerTitleStyle(context)),
        if (!widget.hideDistractions) ...[
          KanbanBoardStyles.gap4h,
          Text(
            'Organize suas tarefas de forma visual',
            style: KanbanBoardStyles.headerSubtitleStyle(context),
          ),
        ],
      ],
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showNewTaskDialog(context: context, onAddTask: _handleAddTask);
      },
      icon: const Icon(Icons.add),
      label: const Text('Nova Tarefa'),
      style: KanbanBoardStyles.addTaskButtonStyle(context),
    );
  }

  Widget _buildColumns(
    BuildContext context,
    List<Task> tasks,
    List<Map<String, dynamic>> columns,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < KanbanBoardStyles.columnsMobileBreakpoint) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ...columns.map((column) => Padding(
                      padding: KanbanBoardStyles.mobileColumnBottomPadding,
                      child: SizedBox(
                        height: KanbanBoardStyles.mobileColumnHeight,
                        child: _buildColumn(column, tasks),
                      ),
                    )),
              ],
            ),
          );
        }

        final children = <Widget>[];
        for (int i = 0; i < columns.length; i++) {
          final columnData = columns[i];
          children.add(
            Expanded(
              child: Padding(
                padding: KanbanBoardStyles.desktopColumnPadding,
                child: _buildColumn(columnData, tasks),
              ),
            ),
          );
          if (i < columns.length - 1) {
            children.add(
              VerticalDivider(
                width: KanbanBoardStyles.dividerWidth,
                thickness: KanbanBoardStyles.dividerThickness,
                color: KanbanBoardStyles.dividerColor(context),
                indent: KanbanBoardStyles.dividerIndent,
                endIndent: KanbanBoardStyles.dividerEndIndent,
              ),
            );
          }
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
      },
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
      onTaskEdited: _handleEditTask,
      highContrast: widget.highContrast,
    );
  }
}
