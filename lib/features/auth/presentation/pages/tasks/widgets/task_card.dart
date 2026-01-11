// ==============================
// 🎴 TASK CARD WIDGET
// ==============================
// Este widget representa visualmente uma tarefa no Kanban
// Similar ao componente TaskCard do React

import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';

/// TaskCard - Widget que exibe uma tarefa
/// 
/// Em React seria:
/// function TaskCard({ task, onDelete }: TaskCardProps) { ... }
/// 
/// No Flutter, usamos classes que herdam de StatelessWidget
class TaskCard extends StatelessWidget {
  /// A tarefa a ser exibida
  final Task task;
  
  /// Callback chamado quando o usuário quer deletar a tarefa
  /// Similar a uma prop function no React: onDelete: (id: string) => void
  final void Function(String id) onDelete;

  /// Constructor
  /// Em Flutter, o "super.key" é necessário para performance do framework
  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
  });

  /// Método build - Similar ao return do componente React
  /// É chamado toda vez que o widget precisa ser reconstruído
  @override
  Widget build(BuildContext context) {
    // Card - Widget do Material Design que cria um cartão com elevação/sombra
    return Card(
      // elevation: sombra do card (0-24)
      elevation: 2,
      
      // shape: bordas arredondadas
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      
      // child: conteúdo interno do Card
      child: Padding(
        padding: const EdgeInsets.all(16),
        
        // Column: empilha widgets verticalmente
        // Similar a <div style={{ display: 'flex', flexDirection: 'column' }}>
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER: Título + Botão Deletar =====
            Row(
              // mainAxisAlignment: como distribuir espaço horizontal
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== TÍTULO DA TAREFA =====
                Expanded(
                  // Expanded: ocupa o espaço disponível
                  // Evita overflow quando o texto é muito longo
                  child: Row(
                    children: [
                      // Ícone de "grip" para indicar que pode arrastar
                      Icon(
                        Icons.drag_indicator,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      
                      // Título da tarefa
                      Expanded(
                        child: Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          // maxLines + overflow: controla texto longo
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // ===== BOTÃO DELETAR =====
                // IconButton: botão circular com ícone
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red.shade400,
                  iconSize: 20,
                  // onPressed: callback quando clicado
                  onPressed: () => onDelete(task.id),
                  tooltip: 'Deletar tarefa',
                ),
              ],
            ),
            
            // ===== DESCRIÇÃO (se existir) =====
            if (task.description != null && task.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                task.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            // ===== TEMPO GASTO (se existir) =====
            if (task.timeSpent != null && task.timeSpent!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${task.timeSpent} de foco',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
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

// ==============================
// 📝 CONCEITOS FLUTTER IMPORTANTES
// ==============================

/*
1. StatelessWidget vs StatefulWidget:
   - StatelessWidget: componente que NÃO tem estado interno
   - Similar a: const TaskCard = ({ task, onDelete }) => { ... }
   - Use quando o widget só depende das props recebidas

2. Layout Widgets:
   - Column: empilha verticalmente (flexDirection: column)
   - Row: empilha horizontalmente (flexDirection: row)
   - Expanded: ocupa espaço disponível (flex: 1)
   - Padding: adiciona espaçamento interno
   - SizedBox: espaçamento fixo entre widgets

3. Conditional Rendering:
   React: {description && <p>{description}</p>}
   Flutter: if (description != null) Text(description)
   
   Ou usando spread operator:
   if (condition) ...[widget1, widget2]

4. Callbacks:
   React: onClick={() => onDelete(id)}
   Flutter: onPressed: () => onDelete(task.id)

5. const Constructor:
   - Usar "const" quando possível melhora performance
   - Flutter pode reutilizar widgets constantes
   - Similar a React.memo() mas automático
*/
