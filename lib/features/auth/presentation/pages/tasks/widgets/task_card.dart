import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/task_card_styles.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final void Function(String id) onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: TaskCardStyles.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TaskCardStyles.radius),
      ),
      child: Padding(
        padding: TaskCardStyles.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.drag_indicator,
                        color: TaskCardStyles.dragIconColor(),
                        size: TaskCardStyles.dragIconSize,
                      ),
                      TaskCardStyles.gap8,
                      Expanded(
                        child: Text(
                          task.title,
                          style: TaskCardStyles.titleText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: TaskCardStyles.deleteColor(),
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
                style: TaskCardStyles.descriptionText(),
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
                    color: TaskCardStyles.timeColor(),
                  ),
                  TaskCardStyles.w4,
                  Text(
                    '${task.timeSpent} de foco',
                    style: TaskCardStyles.timeText(),
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
