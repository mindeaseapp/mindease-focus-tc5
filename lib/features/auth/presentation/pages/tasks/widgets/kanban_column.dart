import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/task_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/kanban_column_styles.dart';

class KanbanColumn extends StatelessWidget {
  final TaskStatus status;
  final String title;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final List<Task> allTasks;
  final void Function(Task task, TaskStatus newStatus) onTaskMoved;
  final void Function(String taskId) onTaskDeleted;
  final Future<void> Function(Task task) onTaskEdited;

  const KanbanColumn({
    super.key,
    required this.status,
    required this.title,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.allTasks,
    required this.onTaskMoved,
    required this.onTaskDeleted,
    required this.onTaskEdited,
  });

  List<Task> get columnTasks =>
      allTasks.where((task) => task.status == status).toList();

  @override
  Widget build(BuildContext context) {
    return DragTarget<Task>(
      onWillAcceptWithDetails: (details) => details.data.status != status,
      onAcceptWithDetails: (details) {
        final task = details.data;
        if (task.status != status) onTaskMoved(task, status);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: isHovered
                ? backgroundColor.withValues(alpha: KanbanColumnStyles.hoverBgAlpha)
                : Colors.transparent,
            border: isHovered
                ? Border.all(
                    color: color,
                    width: KanbanColumnStyles.hoverBorderWidth,
                  )
                : null,
            borderRadius: KanbanColumnStyles.columnRadius(),
          ),
          padding: KanbanColumnStyles.columnPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumnHeader(context),
              KanbanColumnStyles.gap8h,
              Expanded(child: _buildTasksList(context)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColumnHeader(BuildContext context) {
    return Container(
      padding: KanbanColumnStyles.headerPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: KanbanColumnStyles.headerRadius(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: KanbanColumnStyles.headerIconSize),
              KanbanColumnStyles.headerGap8,
              Text(title, style: KanbanColumnStyles.headerTitleStyle(context)),
            ],
          ),
          Container(
            padding: KanbanColumnStyles.counterPadding,
            decoration: BoxDecoration(
              color: KanbanColumnStyles.counterBg(context),
              borderRadius: KanbanColumnStyles.counterRadius(),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.65),
                width: 1,
              ),
            ),
            child: Text(
              '${columnTasks.length}',
              style: KanbanColumnStyles.counterTextStyle(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context) {
    if (columnTasks.isEmpty) return _buildEmptyState(context);

    return ListView.builder(
      itemCount: columnTasks.length,
      itemBuilder: (context, index) => _buildDraggableTask(columnTasks[index]),
    );
  }

  Widget _buildDraggableTask(Task task) {
    final feedback = Material(
      elevation: KanbanColumnStyles.dragFeedbackElevation,
      borderRadius: KanbanColumnStyles.dragRadius(),
      child: SizedBox(
        width: KanbanColumnStyles.dragFeedbackWidth,
        child: Opacity(
          opacity: KanbanColumnStyles.dragFeedbackOpacity,
          child: TaskCard(
            task: task,
            onEdit: () {},
            onDelete: (_) {},
          ),
        ),
      ),
    );

    final childWhenDragging = Opacity(
      opacity: KanbanColumnStyles.childWhenDraggingOpacity,
      child: TaskCard(
        task: task,
        onEdit: () {},
        onDelete: (_) {},
      ),
    );

    final child = Padding(
      padding: KanbanColumnStyles.taskBottomPadding,
      child: TaskCard(
        task: task,
        onEdit: () => onTaskEdited(task),
        onDelete: onTaskDeleted,
      ),
    );

    return kIsWeb
        ? Draggable<Task>(
            data: task,
            feedback: feedback,
            childWhenDragging: childWhenDragging,
            child: child,
          )
        : LongPressDraggable<Task>(
            data: task,
            feedback: feedback,
            childWhenDragging: childWhenDragging,
            child: child,
          );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Container(
        padding: KanbanColumnStyles.emptyPadding,
        decoration: BoxDecoration(
          border: Border.all(
            color: KanbanColumnStyles.emptyBorderColor(context),
            width: KanbanColumnStyles.emptyBorderWidth,
          ),
          borderRadius: KanbanColumnStyles.emptyRadius(),
          color: KanbanColumnStyles.emptyBg(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: KanbanColumnStyles.emptyIconSize,
              color: KanbanColumnStyles.emptyIconColor(context),
            ),
            KanbanColumnStyles.emptyGap8,
            Text(
              'Nenhuma tarefa',
              style: TextStyle(
                fontSize: 14,
                color: KanbanColumnStyles.emptyTextColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
