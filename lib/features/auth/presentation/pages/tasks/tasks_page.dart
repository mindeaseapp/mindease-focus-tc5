import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. Imports de Navegação e Estado
import 'package:mindease_focus/features/routes.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';

// 2. Imports dos Widgets Compartilhados
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart';
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header_styles.dart';
import 'package:mindease_focus/shared/widgets/mindease_drawer/mindease_drawer.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

// 3. Imports dos Widgets da Página
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/pomodoro_timer.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/kanban_board.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // === LÓGICA DE DADOS ===
    final authController = context.watch<AuthController>();
    final userEntity = authController.user;

    final userLabel = (userEntity.name.isNotEmpty)
        ? userEntity.name
        : (userEntity.email.isNotEmpty ? userEntity.email : 'Usuário');

    void goTo(MindEaseNavItem item) {
      switch (item) {
        case MindEaseNavItem.dashboard:
          Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
          break;
        case MindEaseNavItem.tasks:
          break;
        case MindEaseNavItem.profile:
          Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
          break;
      }
    }

    void logout() {
      context.read<AuthController>().logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (_) => false,
      );
    }

    // === LÓGICA DE TEMA ===
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Fundo da barra de abas
    final tabBarBackgroundColor = isDarkMode 
        ? Theme.of(context).colorScheme.surface 
        : Colors.white;

    // Cores dos Ícones/Texto
    Color selectedItemColor;
    Color unselectedItemColor;

    if (isDarkMode) {
      selectedItemColor = Colors.white;
      unselectedItemColor = Colors.white60;
    } else {
      // Usa os estilos do Header para manter consistência
      selectedItemColor = MindEaseHeaderStyles.navFg(context, selected: true);
      unselectedItemColor = MindEaseHeaderStyles.navFg(context, selected: false);
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MindEaseHeader(
          current: MindEaseNavItem.tasks,
          userLabel: userLabel,
          onNavigate: goTo,
          onLogout: logout,
        ),
        
        drawer: AppSizes.isMobile(context)
            ? MindEaseDrawer(
                current: MindEaseNavItem.tasks,
                onNavigate: goTo,
                onLogout: logout,
              )
            : null,
            
        body: Column(
          children: [
            // Container da TabBar
            Container(
              width: double.infinity,
              color: tabBarBackgroundColor,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDarkMode ? Colors.transparent : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  labelColor: selectedItemColor,
                  unselectedLabelColor: unselectedItemColor,
                  indicatorColor: selectedItemColor,
                  indicatorWeight: 3,
                  // Removi overlayColor para evitar erros de versão do Flutter
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.timer_outlined),
                      text: 'Foco',
                    ),
                    Tab(
                      icon: Icon(Icons.view_kanban_outlined),
                      text: 'Tarefas',
                    ),
                  ],
                ),
              ),
            ),

            // Conteúdo
            const Expanded(
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  _PomodoroTabContent(),
                  _KanbanTabContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === WIDGETS DE CONTEÚDO ===

class _PomodoroTabContent extends StatelessWidget {
  const _PomodoroTabContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  Semantics(
                    header: true,
                    child: const Text(
                      'Seu tempo de foco',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const PomodoroTimer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _KanbanTabContent extends StatelessWidget {
  const _KanbanTabContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.transparent 
              : Colors.grey.shade50,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 24),
            child: const Column(
              children: [
                 Expanded(
                   child: KanbanBoard(),
                 ),
              ],
            ),
          ),
        );
      },
    );
  }
}