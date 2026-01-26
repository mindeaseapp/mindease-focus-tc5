import 'package:flutter/material.dart';

class EditTaskDialogStyles {
  static const String title = 'Editar Tarefa';
  static const double contentWidth = 500;

  static const SizedBox gap16 = SizedBox(height: 16);

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
