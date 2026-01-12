import 'package:flutter/material.dart';

class NotFoundStyles {
  // Layout
  static const double maxWidth = 520;
  static const EdgeInsets pagePadding = EdgeInsets.all(24);

  // Espaçamentos
  static const SizedBox gap8 = SizedBox(height: 8);
  static const SizedBox gap16 = SizedBox(height: 16);
  static const SizedBox gap24 = SizedBox(height: 24);

  // Ícone
  static const double iconSize = 56;

  // TextStyles (derivados do tema)
  static TextStyle titleTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  }

  static TextStyle routeTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyMedium ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  }

  // Botões (se quiser padronizar tamanhos)
  static ButtonStyle primaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      minimumSize: const Size(220, 44),
    );
  }
}
