import 'package:flutter/material.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';
import 'package:mindease_focus/features/tasks/presentation/widgets/task_card_styles.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final void Function(String id) onDelete;
  final bool highContrast;
  final bool isSummary;
  final double spacingFactor;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    this.highContrast = false,
    this.isSummary = false,
    this.spacingFactor = 1.0,
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
                SizedBox(width: 8 * spacingFactor),
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
            if (!isSummary && task.description != null && task.description!.isNotEmpty) ...[
              SizedBox(height: 8 * spacingFactor),
              Text(
                task.description!,
                style: TaskCardStyles.descriptionText(context),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (!isSummary && task.timeSpent != null && task.timeSpent!.isNotEmpty) ...[
              SizedBox(height: 12 * spacingFactor),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: TaskCardStyles.timeIconSize,
                    color: TaskCardStyles.timeColor(context),
                  ),
                  SizedBox(width: 4 * spacingFactor),
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
