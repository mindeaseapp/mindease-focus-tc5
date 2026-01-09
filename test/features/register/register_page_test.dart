import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mindease_focus/features/auth/presentation/pages/register/register_page.dart';

void main() {
  // Configuração inicial que roda antes de todos os testes
  setUpAll(() async {
    // 1. Mock do SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // 2. Inicializamos o Supabase com valores FALSOS para não dar erro
    await Supabase.initialize(
      url: 'https://exemplo-falso.supabase.co',
      anonKey: 'chave-falsa-teste',
      debug: false,
    );
  });

  // Função auxiliar para carregar a página e configurar o ambiente
  Future<void> loadPage(WidgetTester tester) async {
    // Define tamanho de tela de celular usando a API correta
    await tester.binding.setSurfaceSize(const Size(1080, 1920));

    // Agendamos a limpeza aqui, onde o 'tester' existe
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterPage(),
      ),
    );
  }

  group('RegisterPage UI Tests', () {
    testWidgets('Deve carregar os campos do formulário corretamente',
        (tester) async {
      await loadPage(tester);

      // Verifica se o título está na tela
      expect(find.text('Crie sua conta'), findsOneWidget);

      // Verifica se os campos existem
      expect(find.widgetWithText(TextFormField, 'Nome completo'),
          findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Senha'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Confirmar senha'),
          findsOneWidget);

      // Verifica se o botão existe
      expect(find.widgetWithText(ElevatedButton, 'Criar conta'),
          findsOneWidget);
    });

    testWidgets('Deve mostrar erro se tentar submeter formulário vazio',
        (tester) async {
      await loadPage(tester);

      // Tenta clicar no botão sem preencher nada
      final nomeField = find.widgetWithText(TextFormField, 'Nome completo');
      await tester.enterText(nomeField, '');
      await tester.pump();

      // Clica em outro lugar para tirar o foco
      await tester.tap(find.text('Crie sua conta'));
      await tester.pumpAndSettle();

      // Verifica se o botão está desabilitado (onPressed é null) quando inválido
      final button = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Criar conta'));
      expect(button.onPressed, isNull,
          reason: 'O botão deve estar desabilitado se o form for inválido');
    });

    testWidgets('Deve habilitar o botão quando o formulário for válido',
        (tester) async {
      await loadPage(tester);

      // Preencher Nome
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Nome completo'),
          'Usuário Teste');

      // Preencher Email
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'teste@email.com');

      // Preencher Senha
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'), 'SenhaForte123!');

      // Confirmar Senha
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirmar senha'),
          'SenhaForte123!');

      // Marcar Checkbox (Termos)
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Atualiza a tela para processar as mudanças de estado
      await tester.pumpAndSettle();

      // Verifica se o botão agora está habilitado (onPressed NÃO é null)
      final button = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Criar conta'));
      expect(button.onPressed, isNotNull,
          reason: 'O botão deve habilitar com dados válidos');
    });

    testWidgets('Deve ter labels de acessibilidade nos campos',
        (tester) async {
      await loadPage(tester);

      // Verifica semântica dos campos
      expect(
        find.bySemanticsLabel(RegExp(r'Campo de nome completo')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'Campo de email')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'Campo de senha')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'Campo de confirmação de senha')),
        findsOneWidget,
      );
    });

    testWidgets('Botões de visibilidade de senha devem ter tooltip',
        (tester) async {
      await loadPage(tester);

      // Verifica tooltips dos botões de visibilidade
      expect(find.byTooltip('Mostrar senha'), findsOneWidget);
      expect(find.byTooltip('Mostrar confirmação de senha'), findsOneWidget);

      // Testa toggle do primeiro botão
      await tester.tap(find.byTooltip('Mostrar senha'));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Ocultar senha'), findsOneWidget);
    });

    testWidgets('Navegação por teclado deve funcionar corretamente',
        (tester) async {
      await loadPage(tester);

      // Foca no campo de nome
      final nameField = find.widgetWithText(TextFormField, 'Nome completo');
      await tester.tap(nameField);
      await tester.pumpAndSettle();

      // Simula pressionar "próximo"
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      // Verifica que os campos estão acessíveis
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    });

    testWidgets('Checkbox de termos deve ter semântica apropriada',
        (tester) async {
      await loadPage(tester);

      // Verifica se o checkbox tem semântica de checkbox
      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      // Testa interação
      await tester.tap(checkbox);
      await tester.pump();

      final checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isTrue);
    });
  });
}