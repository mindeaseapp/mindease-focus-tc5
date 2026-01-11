// ==============================
// ➕ NEW TASK DIALOG
// ==============================
// Dialog (modal) para criar uma nova tarefa
// Similar ao NewTaskDialog do React

import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';

/// NewTaskDialog - Widget que mostra um formulário para criar tarefa
/// 
/// Este é um StatefulWidget porque tem estado interno (valores do form)
/// Em React seria: const [formData, setFormData] = useState({...})
class NewTaskDialog extends StatefulWidget {
  /// Callback chamado quando uma tarefa é criada
  /// Similar a: onAddTask: (task: Omit<Task, 'id'>) => void
  final void Function(Task task) onAddTask;

  const NewTaskDialog({
    super.key,
    required this.onAddTask,
  });

  /// createState - Cria o objeto State que gerencia o estado interno
  /// Similar ao corpo da função do componente React com useState
  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

/// State class - Contém o estado e a lógica do widget
/// O "_" na frente torna a classe privada (só acessível neste arquivo)
class _NewTaskDialogState extends State<NewTaskDialog> {
  // ===== CONTROLLERS =====
  // Controllers gerenciam o texto dos TextFields
  // Similar a: const [title, setTitle] = useState('')
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // ===== FORM KEY =====
  // Usado para validar o formulário
  final _formKey = GlobalKey<FormState>();
  
  // ===== ESTADO LOCAL =====
  // Status selecionado no dropdown
  TaskStatus _selectedStatus = TaskStatus.todo;

  /// dispose - Método chamado quando o widget é removido da árvore
  /// Similar ao cleanup do useEffect: return () => { ... }
  /// IMPORTANTE: sempre limpar controllers para evitar memory leaks!
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Método para submeter o formulário
  void _handleSubmit() {
    // Valida o form - chama validator de cada TextFormField
    if (_formKey.currentState!.validate()) {
      // Cria a nova tarefa
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID baseado em timestamp
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        status: _selectedStatus,
      );

      // Chama o callback passado como prop
      widget.onAddTask(newTask);

      // Fecha o dialog
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // AlertDialog - Widget do Material Design para dialogs/modals
    return AlertDialog(
      // Título do dialog
      title: const Text('Criar Nova Tarefa'),
      
      // Conteúdo do dialog
      content: SizedBox(
        width: 500, // Largura máxima em desktop
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Altura mínima necessária
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
                // Validação - retorna erro ou null
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
                // Ação do teclado - avançar para próximo campo
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
                maxLines: 3, // Campo de múltiplas linhas
                textInputAction: TextInputAction.done,
                // Opcional - sem validação
              ),
              
              const SizedBox(height: 16),
              
              // ===== DROPDOWN STATUS =====
              DropdownButtonFormField<TaskStatus>(
                value: _selectedStatus,
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
                  if (newValue != null) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      
      // ===== BOTÕES DE AÇÃO =====
      actions: [
        // Botão Cancelar
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        
        // Botão Criar
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text('Criar Tarefa'),
        ),
      ],
    );
  }
}

/// Função helper para mostrar o dialog
/// Similar a: setOpen(true) no React
/// 
/// Uso:
/// showNewTaskDialog(
///   context: context,
///   onAddTask: (task) => print(task),
/// );
Future<void> showNewTaskDialog({
  required BuildContext context,
  required void Function(Task task) onAddTask,
}) {
  return showDialog(
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
