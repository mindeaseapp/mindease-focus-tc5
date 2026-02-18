import 'package:flutter/material.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';
import 'package:mindease_focus/features/tasks/presentation/widgets/edit_task_dialog_styles.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;
  final Future<void> Function(String title, String description, TaskStatus status) onSave;

  const EditTaskDialog({
    super.key,
    required this.task,
    required this.onSave,
  });

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TaskStatus _selectedStatus;

  bool _saving = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description ?? '');
    _selectedStatus = widget.task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _localError = null;
    });

    try {
      await widget.onSave(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _selectedStatus,
      );

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _localError = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(EditTaskDialogStyles.title),
      content: SizedBox(
        width: EditTaskDialogStyles.contentWidth,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_localError != null) ...[
                  Text(
                    _localError!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  EditTaskDialogStyles.gap16,
                ],
                TextFormField(
                  controller: _titleController,
                  decoration: EditTaskDialogStyles.titleDecoration,
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Insira um título' : null,
                  textInputAction: TextInputAction.next,
                  enabled: !_saving,
                ),
                EditTaskDialogStyles.gap16,
                TextFormField(
                  controller: _descriptionController,
                  decoration: EditTaskDialogStyles.descriptionDecoration,
                  maxLines: EditTaskDialogStyles.descriptionMaxLines,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _saving ? null : _handleSubmit(),
                  enabled: !_saving,
                ),
                EditTaskDialogStyles.gap16,
                DropdownButtonFormField<TaskStatus>(
                  initialValue: _selectedStatus, // ✅ corrige o warning
                  decoration: EditTaskDialogStyles.statusDecoration,
                  items: const [
                    DropdownMenuItem(value: TaskStatus.todo, child: Text('A Fazer')),
                    DropdownMenuItem(value: TaskStatus.inProgress, child: Text('Em Andamento')),
                    DropdownMenuItem(value: TaskStatus.done, child: Text('Concluído')),
                  ],
                  onChanged: _saving ? null : (v) {
                    if (v == null) return;
                    setState(() => _selectedStatus = v);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text(EditTaskDialogStyles.cancelLabel),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _handleSubmit,
          child: Text(_saving ? 'Salvando...' : EditTaskDialogStyles.submitLabel),
        ),
      ],
    );
  }
}

Future<bool> showEditTaskDialog({
  required BuildContext context,
  required Task task,
  required Future<void> Function(String title, String description, TaskStatus status) onSave,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => EditTaskDialog(task: task, onSave: onSave),
  );
  return result == true;
}
