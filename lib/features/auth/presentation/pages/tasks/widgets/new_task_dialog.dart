import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';

class NewTaskDialog extends StatefulWidget {
  // ✅ Agora recebe uma função que aceita Strings e Status
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

    // ✅ Envia os dados para quem chamou (KanbanBoard)
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
      title: const Text('Criar Nova Tarefa'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título da Tarefa',
                    hintText: 'Ex: Estudar Flutter',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.trim().isEmpty ? 'Insira um título' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição (opcional)',
                    prefixIcon: Icon(Icons.notes),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSubmit(),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskStatus>(
                  initialValue: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status Inicial',
                    prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: TaskStatus.todo, child: Text('A Fazer')),
                    DropdownMenuItem(value: TaskStatus.inProgress, child: Text('Em Andamento')),
                    DropdownMenuItem(value: TaskStatus.done, child: Text('Concluído')),
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
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text('Criar Tarefa'),
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