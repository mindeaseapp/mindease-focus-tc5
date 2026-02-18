import 'package:flutter/material.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';
import 'package:mindease_focus/features/tasks/presentation/widgets/new_task_dialog_styles.dart';

class NewTaskDialog extends StatefulWidget {
  final void Function(String title, String description, TaskStatus status) onAddTask;

  const NewTaskDialog({
    super.key,
    required this.onAddTask,
  });

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskStatus _selectedStatus = TaskStatus.todo;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    widget.onAddTask(
      _titleController.text.trim(),
      _descriptionController.text.trim(),
      _selectedStatus,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(NewTaskDialogStyles.title),
      content: SizedBox(
        width: NewTaskDialogStyles.contentWidth,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: NewTaskDialogStyles.titleDecoration,
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Insira um título' : null,
                  textInputAction: TextInputAction.next,
                ),
                NewTaskDialogStyles.gap16,
                TextFormField(
                  controller: _descriptionController,
                  decoration: NewTaskDialogStyles.descriptionDecoration,
                  maxLines: NewTaskDialogStyles.descriptionMaxLines,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSubmit(),
                ),
                NewTaskDialogStyles.gap16,
                DropdownButtonFormField<TaskStatus>(
                  initialValue: _selectedStatus,
                  decoration: NewTaskDialogStyles.statusDecoration,
                  items: const [
                    DropdownMenuItem(
                      value: TaskStatus.todo,
                      child: Text('A Fazer'),
                    ),
                    DropdownMenuItem(
                      value: TaskStatus.inProgress,
                      child: Text('Em Andamento'),
                    ),
                    DropdownMenuItem(
                      value: TaskStatus.done,
                      child: Text('Concluído'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _selectedStatus = v!),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(NewTaskDialogStyles.cancelLabel),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text(NewTaskDialogStyles.submitLabel),
        ),
      ],
    );
  }
}

Future<void> showNewTaskDialog({
  required BuildContext context,
  required void Function(String title, String description, TaskStatus status) onAddTask,
}) {
  return showDialog(
    context: context,
    builder: (context) => NewTaskDialog(onAddTask: onAddTask),
  );
}
