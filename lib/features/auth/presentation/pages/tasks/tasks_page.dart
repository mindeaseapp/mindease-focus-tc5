// ==============================
// 📄 TASKS PAGE
// ==============================
// Página principal de tarefas com Pomodoro Timer + Kanban Board
// Similar ao TasksPage do React

import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/pomodoro_timer.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/kanban_board.dart';

/// TasksPage - Página completa de gerenciamento de tarefas
/// 
/// Em React seria:
/// export function TasksPage() {
///   return (
///     <div>
///       <PomodoroTimer />
///       <KanbanBoard />
///     </div>
///   );
/// }
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar - Barra superior
      appBar: AppBar(
        title: const Text('Kanban Cognitivo'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      
      // Body - Conteúdo principal
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Mobile: layout vertical (timer acima, kanban abaixo)
          if (constraints.maxWidth < 900) {
            return _buildMobileLayout();
          }
          
          // Desktop: layout horizontal (timer à esquerda, kanban à direita)
          return _buildDesktopLayout();
        },
      ),
    );
  }

  /// Layout para mobile (vertical)
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Timer Pomodoro
          const PomodoroTimer(),
          
          const SizedBox(height: 24),
          
          // Kanban Board
          SizedBox(
            height: 600, // Altura fixa para o kanban
            child: const KanbanBoard(),
          ),
        ],
      ),
    );
  }

  /// Layout para desktop (com scroll vertical)
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Timer Pomodoro no topo
          const PomodoroTimer(),
          
          const SizedBox(height: 24),
          
          // Kanban Board com altura mínima fixa
          // Isso garante que o Kanban sempre tenha espaço adequado
          // e permite scroll vertical se necessário
          SizedBox(
            height: 700, // Altura mínima para visualização adequada
            child: const KanbanBoard(),
          ),
        ],
      ),
    );
  }
}

// ==============================
// 📝 CONCEITOS FLUTTER IMPORTANTES
// ==============================

/*
1. Scaffold - Estrutura básica de página:
   Similar ao layout base do Material Design
   - appBar: barra superior
   - body: conteúdo principal
   - floatingActionButton: botão flutuante (opcional)
   - drawer: menu lateral (opcional)

2. AppBar - Barra superior:
   Material Design app bar
   - title: título da página
   - backgroundColor: cor de fundo
   - foregroundColor: cor do texto/ícones
   - elevation: sombra (profundidade)

3. LayoutBuilder - Layout responsivo:
   Permite construir layouts diferentes baseado no espaço disponível
   - Similar ao useMediaQuery + conditional rendering no React
   - Recebe constraints (largura/altura disponível)

4. SingleChildScrollView:
   Permite scroll quando conteúdo excede espaço disponível
   Similar a: overflow-y: auto no CSS
   - Útil para mobile quando conteúdo é grande

5. SizedBox com altura:
   Define tamanho fixo para um widget
   - Útil para limitar altura de componentes complexos
   - Evita que componente cresça infinitamente

6. Expanded:
   Ocupa todo espaço disponível na direção principal
   Similar a: flex: 1 no CSS
   - Dentro de Column: ocupa altura restante
   - Dentro de Row: ocupa largura restante

7. Composição de Widgets:
   Flutter é 100% baseado em composição
   - TasksPage compõe PomodoroTimer + KanbanBoard
   - Cada widget é independente e reutilizável
   - Similar a componentes React

8. const Widgets:
   Usar "const" sempre que possível melhora performance
   - Flutter pode reutilizar widgets constantes
   - Não precisa reconstruir quando parent atualiza
   - Similar a React.memo() mas automático
*/
