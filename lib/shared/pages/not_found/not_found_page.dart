import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mindease_focus/core/navigation/routes.dart';
import 'package:mindease_focus/shared/pages/not_found/not_found_styles.dart';

class NotFoundPage extends StatelessWidget {
  final String? requestedRoute;

  const NotFoundPage({super.key, this.requestedRoute});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final isLoggedIn = user != null;

    final routeText = (requestedRoute == null || requestedRoute!.isEmpty)
        ? 'Rota desconhecida'
        : requestedRoute!;

    return Scaffold(
      appBar: AppBar(
        // ✅ REMOVE a seta/back do AppBar
        automaticallyImplyLeading: false,

        title: const Text('Página não encontrada'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: NotFoundStyles.maxWidth),
          child: Padding(
            padding: NotFoundStyles.pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off,
                  size: NotFoundStyles.iconSize,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                NotFoundStyles.gap16,
                Semantics(
                  header: true,
                  child: Text(
                    'Oops! Não encontrei essa página.',
                    textAlign: TextAlign.center,
                    style: NotFoundStyles.titleTextStyle(context),
                  ),
                ),
                NotFoundStyles.gap8,
                Text(
                  'Rota: $routeText',
                  textAlign: TextAlign.center,
                  style: NotFoundStyles.routeTextStyle(context),
                ),
                NotFoundStyles.gap24,

                ElevatedButton(
                  style: NotFoundStyles.primaryButtonStyle(context),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      isLoggedIn ? AppRoutes.dashboard : AppRoutes.login,
                      (route) => false,
                    );
                  },
                  child: Text(isLoggedIn ? 'Voltar pro Dashboard' : 'Ir para Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
