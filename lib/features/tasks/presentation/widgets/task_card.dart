import 'package:flutter/material.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';
import 'package:mindease_focus/features/tasks/presentation/widgets/task_card_styles.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final void Function(String id) onDelete;
  final bool highContrast;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    this.highContrast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: TaskCardStyles.elevation,
      shape: TaskCardStyles.cardShape(context, highContrast: highContrast),
      color: TaskCardStyles.cardBg(context, highContrast: highContrast),
      child: Padding(
        padding: TaskCardStyles.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.drag_indicator,
                  color: TaskCardStyles.dragIconColor(context),
                  size: TaskCardStyles.dragIconSize,
                ),
                TaskCardStyles.gap8,
                Expanded(
                  child: Text(
                    task.title,
                    style: TaskCardStyles.titleText(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  color: TaskCardStyles.editColor(context),
                  iconSize: TaskCardStyles.editIconSize,
                  onPressed: onEdit,
                  tooltip: 'Editar tarefa',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: TaskCardStyles.deleteColor(context),
                  iconSize: TaskCardStyles.deleteIconSize,
                  onPressed: () => onDelete(task.id),
                  tooltip: 'Deletar tarefa',
                ),
              ],
            ),
            if (task.description != null && task.description!.isNotEmpty) ...[
              TaskCardStyles.h8,
              Text(
                task.description!,
                style: TaskCardStyles.descriptionText(context),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (task.timeSpent != null && task.timeSpent!.isNotEmpty) ...[
              TaskCardStyles.h12,
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: TaskCardStyles.timeIconSize,
                    color: TaskCardStyles.timeColor(context),
                  ),
                  TaskCardStyles.w4,
                  Text(
                    '${task.timeSpent} de foco',
                    style: TaskCardStyles.timeText(context),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
