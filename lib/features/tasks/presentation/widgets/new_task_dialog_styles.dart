import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class NewTaskDialogStyles {
  // Dialog
  static const String title = 'Criar Nova Tarefa';
  static const double contentWidth = AppSizes.dialogWidthDesktop;

  // Spacing
  static const SizedBox gap16 = AppSpacing.gapMd;

  // Fields - Title
  static const InputDecoration titleDecoration = InputDecoration(
    labelText: 'Título da Tarefa',
    hintText: 'Ex: Estudar Flutter',
    prefixIcon: Icon(Icons.title),
    border: OutlineInputBorder(),
  );

  // Fields - Description
  static const InputDecoration descriptionDecoration = InputDecoration(
    labelText: 'Descrição (opcional)',
    prefixIcon: Icon(Icons.notes),
    border: OutlineInputBorder(),
  );

  static const int descriptionMaxLines = 3;

  // Fields - Status
  static const InputDecoration statusDecoration = InputDecoration(
    labelText: 'Status Inicial',
    prefixIcon: Icon(Icons.flag),
    border: OutlineInputBorder(),
  );

  // Actions
  static const String cancelLabel = 'Cancelar';
  static const String submitLabel = 'Criar Tarefa';
}
