import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';

class NewTaskDialog extends StatefulWidget {
  final void Function(Task task) onAddTask;

  const NewTaskDialog({
    super.key,
    required this.onAddTask,
  });

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  final _formKey = GlobalKey<FormState>();

  // ✅ controllers (não usar initialValue junto com controller)
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

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      status: _selectedStatus,
    );

    widget.onAddTask(newTask);
    Navigator.of(context).pop(newTask);
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
                // ===== CAMPO TÍTULO =====
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título da Tarefa',
                    hintText: 'Ex: Estudar React Hooks',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Por favor, insira um título';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                // ===== CAMPO DESCRIÇÃO =====
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição (opcional)',
                    hintText: 'Adicione detalhes sobre a tarefa...',
                    prefixIcon: Icon(Icons.notes),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSubmit(),
                ),

                const SizedBox(height: 16),

                // ===== DROPDOWN STATUS =====
                DropdownButtonFormField<TaskStatus>(
                  // ✅ LINT FIX: trocar value -> initialValue
                  initialValue: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status Inicial',
                    prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(),
                  ),
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
                  onChanged: (TaskStatus? newValue) {
                    if (newValue == null) return;
                    setState(() => _selectedStatus = newValue);
                  },
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

Future<Task?> showNewTaskDialog({
  required BuildContext context,
  required void Function(Task task) onAddTask,
}) {
  return showDialog<Task>(
    context: context,
    builder: (context) => NewTaskDialog(onAddTask: onAddTask),
  );
}


// ==============================
// 📝 CONCEITOS FLUTTER IMPORTANTES
// ==============================

/*
1. StatefulWidget vs StatelessWidget:
   StatelessWidget: sem estado (const TaskCard = () => {...})
   StatefulWidget: com estado (const [count, setCount] = useState(0))

2. TextEditingController:
   React: const [title, setTitle] = useState('')
   Flutter: final _controller = TextEditingController()
            _controller.text // ler valor
            _controller.dispose() // limpar (importante!)

3. setState():
   React: setCount(count + 1)
   Flutter: setState(() { count++; })
   - Avisa o Flutter para reconstruir o widget
   - Só funciona dentro de StatefulWidget

4. Form Validation:
   Flutter tem sistema built-in de validação
   - GlobalKey<FormState> para acessar o form
   - validator: função que retorna erro ou null
   - _formKey.currentState!.validate() verifica tudo

5. showDialog():
   React: const [open, setOpen] = useState(false)
          {open && <Dialog>...</Dialog>}
   Flutter: showDialog(context, builder: (context) => Dialog(...))
   - Retorna Future<T?> com resultado do dialog
   - Navigator.pop() fecha o dialog

6. widget.property:
   Dentro do State, use "widget.prop" para acessar props
   - widget.onAddTask()
   - Similar a "props.onAddTask()" em React
*/
