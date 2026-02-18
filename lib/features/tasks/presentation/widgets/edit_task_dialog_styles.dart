import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class EditTaskDialogStyles {
  static const String title = 'Editar Tarefa';
  static const double contentWidth = AppSizes.dialogWidthDesktop;

  static const SizedBox gap16 = AppSpacing.gapMd;

  static const InputDecoration titleDecoration = InputDecoration(
    labelText: 'Título da Tarefa',
    prefixIcon: Icon(Icons.title),
    border: OutlineInputBorder(),
  );

  static const InputDecoration descriptionDecoration = InputDecoration(
    labelText: 'Descrição (opcional)',
    prefixIcon: Icon(Icons.notes),
    border: OutlineInputBorder(),
  );

  static const int descriptionMaxLines = 3;

  static const InputDecoration statusDecoration = InputDecoration(
    labelText: 'Status',
    prefixIcon: Icon(Icons.flag),
    border: OutlineInputBorder(),
  );

  static const String cancelLabel = 'Cancelar';
  static const String submitLabel = 'Salvar';
}
