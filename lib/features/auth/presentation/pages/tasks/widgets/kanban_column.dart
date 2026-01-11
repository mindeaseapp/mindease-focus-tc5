// ==============================
// 📋 KANBAN COLUMN WIDGET
// ==============================
// Representa uma coluna do quadro Kanban (A Fazer, Em Andamento, Concluído)
// Aceita tarefas arrastadas (DragTarget)

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/task_card.dart';

/// KanbanColumn - Uma coluna do quadro Kanban
/// 
/// Em React seria um componente que:
/// 1. Filtra tasks pelo status
/// 2. Aceita drop de tarefas (onDrop)
/// 3. Renderiza a lista de TaskCards
class KanbanColumn extends StatelessWidget {
  /// Status desta coluna (define quais tasks mostrar)
  final TaskStatus status;
  
  /// Título da coluna
  final String title;
  
  /// Ícone da coluna
  final IconData icon;
  
  /// Cor do ícone e header
  final Color color;
  
  /// Cor de fundo do header
  final Color backgroundColor;
  
  /// Lista completa de todas as tarefas
  final List<Task> allTasks;
  
  /// Callback quando uma tarefa é solta (dropped) nesta coluna
  /// Similar a: onDrop: (e: DragEvent, newStatus) => void
  final void Function(Task task, TaskStatus newStatus) onTaskMoved;
  
  /// Callback quando uma tarefa é deletada
  final void Function(String taskId) onTaskDeleted;

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
  });

  /// Getter que filtra apenas as tarefas desta coluna
  /// Similar a: const columnTasks = tasks.filter(task => task.status === columnId)
  List<Task> get columnTasks {
    return allTasks.where((task) => task.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    // DragTarget - Widget que ACEITA itens arrastados
    // Similar ao onDragOver + onDrop do HTML5
    return DragTarget<Task>(
      // onWillAccept - Verifica se pode aceitar o item
      // Retornar true = pode soltar aqui
      // Retornar false = não pode soltar aqui
      onWillAccept: (task) {
        // Aceita qualquer tarefa (mesmo que já esteja nesta coluna)
        return task != null;
      },
      
      // onAccept - Chamado quando o item é solto
      // Similar ao onDrop do HTML5
      onAccept: (task) {
        // Só move se for uma coluna diferente
        if (task.status != status) {
          onTaskMoved(task, status);
        }
      },
      
      // builder - Constrói a UI da coluna
      // candidateData: itens sendo arrastados sobre esta coluna
      // rejectedData: itens rejeitados (onWillAccept retornou false)
      builder: (context, candidateData, rejectedData) {
        // Verifica se algo está sendo arrastado sobre esta coluna
        final isHovered = candidateData.isNotEmpty;
        
        return Container(
          // Muda a cor de fundo quando algo é arrastado sobre a coluna
          decoration: BoxDecoration(
            color: isHovered 
                ? backgroundColor.withOpacity(0.3) 
                : Colors.transparent,
            border: isHovered
                ? Border.all(color: color, width: 2)
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER DA COLUNA =====
              _buildColumnHeader(),
              
              const SizedBox(height: 8),
              
              // ===== LISTA DE TAREFAS =====
              Expanded(
                child: _buildTasksList(context),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Constrói o header da coluna com ícone, título e contador
  Widget _buildColumnHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ícone + Título
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          
          // Contador de tarefas
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${columnTasks.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói a lista de tarefas (ou mensagem de vazio)
  Widget _buildTasksList(BuildContext context) {
    // Se não há tarefas, mostra mensagem
    if (columnTasks.isEmpty) {
      return _buildEmptyState();
    }

    // ListView.builder - Lista otimizada para muitos itens
    // Similar ao tasks.map(task => <TaskCard key={task.id} />)
    return ListView.builder(
      itemCount: columnTasks.length,
      itemBuilder: (context, index) {
        final task = columnTasks[index];
        return _buildDraggableTask(task);
      },
    );
  }

  /// Constrói um task card arrastável
  /// Usa Draggable na web (arraste imediato) e LongPressDraggable no mobile (evita conflito scroll)
  Widget _buildDraggableTask(Task task) {
    // Widgets comuns para feedback e childWhenDragging
    final feedback = Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 280,
        child: Opacity(
          opacity: 0.8,
          child: TaskCard(
            task: task,
            onDelete: (_) {}, // Desabilitado durante drag
          ),
        ),
      ),
    );

    final childWhenDragging = Opacity(
      opacity: 0.3,
      child: TaskCard(
        task: task,
        onDelete: (_) {},
      ),
    );

    final child = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TaskCard(
        task: task,
        onDelete: onTaskDeleted,
      ),
    );

    // Web: usa Draggable (arraste imediato com mouse)
    if (kIsWeb) {
      return Draggable<Task>(
        data: task,
        feedback: feedback,
        childWhenDragging: childWhenDragging,
        child: child,
      );
    }

    // Mobile/Desktop nativo: usa LongPressDraggable (evita conflito com scroll)
    return LongPressDraggable<Task>(
      data: task,
      feedback: feedback,
      childWhenDragging: childWhenDragging,
      child: child,
    );
  }

  /// Widget mostrado quando a coluna está vazia
  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhuma tarefa',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================
// 📝 CONCEITOS FLUTTER IMPORTANTES
// ==============================

/*
1. DragTarget<T> - Área que ACEITA drops
   React: onDragOver + onDrop
   Flutter: DragTarget(
     onWillAccept: (data) => true/false,
     onAccept: (data) => handleDrop(data),
     builder: (context, candidates, rejected) => Widget,
   )

2. LongPressDraggable<T> - Widget ARRASTÁVEL
   React: draggable={true} + onDragStart
   Flutter: LongPressDraggable(
     data: object,              // dados transferidos
     feedback: Widget,          // UI durante drag
     childWhenDragging: Widget, // UI no lugar original
     child: Widget,             // UI normal
   )
   
   Por que LongPress?
   - Melhor para mobile (evita conflito com scroll)
   - Em desktop, pode usar Draggable normal

3. Getter Computed:
   List<Task> get columnTasks { ... }
   Similar a: const columnTasks = useMemo(() => ..., [tasks])
   - Calcula valor derivado do estado
   - Recalculado automaticamente quando allTasks muda

4. ListView.builder:
   Similar ao .map() do React, mas OTIMIZADO
   - Só renderiza itens visíveis (virtualização)
   - Perfeito para listas longas
   - builder: chamado para cada item

5. Feedback Visual no Drag:
   - feedback: cópia semi-transparente sendo arrastada
   - childWhenDragging: original fica opaco
   - Ajuda usuário ver onde está arrastando

6. onWillAccept vs onAccept:
   onWillAccept: validação (pode soltar aqui?)
   onAccept: ação (moveu para cá!)
*/
