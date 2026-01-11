// ==============================
// 🎯 KANBAN BOARD WIDGET
// ==============================
// Quadro Kanban completo com 3 colunas e gerenciamento de estado
// Similar ao componente KanbanBoard do React

import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/kanban_column.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/new_task_dialog.dart';

/// KanbanBoard - Quadro Kanban completo com gerenciamento de estado
/// 
/// Em React seria:
/// const [tasks, setTasks] = useState<Task[]>(initialTasks)
/// 
/// StatefulWidget porque gerencia o estado das tarefas
class KanbanBoard extends StatefulWidget {
  const KanbanBoard({super.key});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  // ===== ESTADO: Lista de tarefas =====
  // Similar a: const [tasks, setTasks] = useState(initialTasks)
  List<Task> _tasks = List.from(initialTasks);

  // ===== DEFINIÇÃO DAS COLUNAS =====
  // Similar ao array "columns" do React
  final List<Map<String, dynamic>> _columns = [
    {
      'id': TaskStatus.todo,
      'title': 'A Fazer',
      'icon': Icons.circle_outlined,
      'color': Colors.grey.shade600,
      'bgColor': Colors.grey.shade50,
    },
    {
      'id': TaskStatus.inProgress,
      'title': 'Em Andamento',
      'icon': Icons.pending_outlined,
      'color': Colors.blue.shade600,
      'bgColor': Colors.blue.shade50,
    },
    {
      'id': TaskStatus.done,
      'title': 'Concluído',
      'icon': Icons.check_circle_outline,
      'color': Colors.green.shade600,
      'bgColor': Colors.green.shade50,
    },
  ];

  /// Adiciona uma nova tarefa
  /// Similar a: const handleAddTask = (newTask) => setTasks([...tasks, task])
  void _handleAddTask(Task newTask) {
    setState(() {
      _tasks = [..._tasks, newTask];
    });
    
    // Feedback para o usuário
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa "${newTask.title}" criada!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  /// Deleta uma tarefa pelo ID
  /// Similar a: setTasks(tasks.filter(task => task.id !== id))
  void _handleDeleteTask(String taskId) {
    // Encontra a tarefa antes de deletar (para mostrar o nome)
    final task = _tasks.firstWhere((t) => t.id == taskId);
    
    setState(() {
      _tasks = _tasks.where((task) => task.id != taskId).toList();
    });
    
    // Feedback para o usuário
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa "${task.title}" deletada!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  /// Move uma tarefa para um novo status
  /// Similar a: setTasks(tasks.map(t => t.id === task.id ? {...t, status} : t))
  void _handleTaskMoved(Task task, TaskStatus newStatus) {
    setState(() {
      _tasks = _tasks.map((t) {
        // Se for a tarefa arrastada, atualiza o status
        if (t.id == task.id) {
          return t.copyWith(status: newStatus);
        }
        return t;
      }).toList();
    });
    
    // Feedback para o usuário
    final statusText = _getStatusText(newStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa movida para "$statusText"'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  /// Helper para obter texto do status
  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'A Fazer';
      case TaskStatus.inProgress:
        return 'Em Andamento';
      case TaskStatus.done:
        return 'Concluído';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        
        _buildHeader(),
        
        const SizedBox(height: 24),
        
        // ===== COLUNAS DO KANBAN =====
        Expanded(
          child: _buildColumns(),
        ),
      ],
    );
  }

  // ==============================
  // 📱 HEADER RESPONSIVO
  // ==============================
  
  /// Constrói o header (delega para mobile ou desktop)
  /// Similar a: const isMobile = useMediaQuery()
  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile: largura < 600px
        if (constraints.maxWidth < 600) {
          return _buildHeaderMobile();
        }
        // Desktop: largura >= 600px
        return _buildHeaderDesktop();
      },
    );
  }

  /// Header para mobile (Column - empilhado)
  Widget _buildHeaderMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título e descrição
        _buildHeaderTitle(),
        
        const SizedBox(height: 16),
        
        // Botão full width
        SizedBox(
          width: double.infinity,
          child: _buildAddTaskButton(),
        ),
      ],
    );
  }

  /// Header para desktop (Row - lado a lado)
  Widget _buildHeaderDesktop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Título à esquerda
        _buildHeaderTitle(),
        
        // Botão à direita
        _buildAddTaskButton(),
      ],
    );
  }

  /// Título e descrição (reutilizável)
  Widget _buildHeaderTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quadro Kanban',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Organize suas tarefas de forma visual',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  /// Botão adicionar tarefa (reutilizável)
  Widget _buildAddTaskButton() {
    return ElevatedButton.icon(
      onPressed: () {
        showNewTaskDialog(
          context: context,
          onAddTask: _handleAddTask,
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Nova Tarefa'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
      ),
    );
  }

  /// Constrói as 3 colunas do Kanban
  Widget _buildColumns() {
    // LayoutBuilder - Permite construir layout baseado no espaço disponível
    // Similar ao useMediaQuery do React
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile: colunas empilhadas verticalmente
        if (constraints.maxWidth < 900) {
          return _buildMobileLayout();
        }
        
        // Desktop: colunas lado a lado
        return _buildDesktopLayout();
      },
    );
  }

  /// Layout para desktop (colunas lado a lado)
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _columns.map((column) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildColumn(column),
          ),
        );
      }).toList(),
    );
  }

  /// Layout para mobile (colunas empilhadas)
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ..._columns.map((column) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 300, // Altura fixa para cada coluna
                child: _buildColumn(column),
              ),
            );
          }),
          
          // Dica para mobile
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '💡 Dica: Pressione e segure uma tarefa para arrastá-la',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói uma coluna individual
  Widget _buildColumn(Map<String, dynamic> column) {
    return KanbanColumn(
      status: column['id'] as TaskStatus,
      title: column['title'] as String,
      icon: column['icon'] as IconData,
      color: column['color'] as Color,
      backgroundColor: column['bgColor'] as Color,
      allTasks: _tasks,
      onTaskMoved: _handleTaskMoved,
      onTaskDeleted: _handleDeleteTask,
    );
  }
}

// ==============================
// 📝 CONCEITOS FLUTTER IMPORTANTES
// ==============================

/*
1. Gerenciamento de Estado Local:
   React: const [tasks, setTasks] = useState([])
   Flutter: 
   - Declara: List<Task> _tasks = []
   - Atualiza: setState(() { _tasks = newTasks; })
   - setState() avisa o Flutter para reconstruir o widget

2. Imutabilidade ao Atualizar Estado:
   ❌ Errado: _tasks.add(newTask); setState(() {})
   ✅ Certo: setState(() { _tasks = [..._tasks, newTask]; })
   
   Por quê? Flutter compara referências para otimização
   Criar nova lista garante que Flutter detecta a mudança

3. Atualizar Item em Lista:
   React: setTasks(tasks.map(t => t.id === id ? {...t, status} : t))
   Flutter: _tasks = _tasks.map((t) => 
              t.id == id ? t.copyWith(status: status) : t
            ).toList()

4. LayoutBuilder - Layout Responsivo:
   Similar ao useMediaQuery do React
   - Recebe constraints (largura/altura disponível)
   - Pode renderizar layouts diferentes baseado no espaço
   - Perfeito para mobile vs desktop

5. ScaffoldMessenger - Feedback Visual:
   Similar a toast/notification libraries do React
   - showSnackBar() mostra mensagem temporária
   - Feedback para ações do usuário (criou, deletou, moveu)

6. Spread Operator em Lists:
   Dart tem spread operator como JavaScript!
   - [...list, newItem] adiciona ao final
   - [newItem, ...list] adiciona ao início
   - [...list1, ...list2] concatena listas

7. where() vs filter():
   React: tasks.filter(task => task.id !== id)
   Flutter: tasks.where((task) => task.id != id).toList()
   - where() retorna Iterable (lazy)
   - .toList() converte para List

8. map() em ambos:
   React e Flutter têm sintaxe similar!
   columns.map((col) => <Column />).toList()
*/
