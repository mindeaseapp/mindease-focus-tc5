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
    // Define tamanho de tela de celular
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    // CORREÇÃO: Agendamos a limpeza aqui, onde o 'tester' existe.
    // Isso garante que ao final de cada teste, o tamanho da tela volte ao normal.
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterPage(),
      ),
    );
  }

  group('RegisterPage UI Tests', () {
    testWidgets('Deve carregar os campos do formulário corretamente', (tester) async {
      await loadPage(tester);

      // Verifica se o título está na tela
      expect(find.text('Crie sua conta'), findsOneWidget);

      // Verifica se os campos existem
      expect(find.widgetWithText(TextFormField, 'Nome completo'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Senha'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Confirmar senha'), findsOneWidget);
      
      // Verifica se o botão existe
      expect(find.widgetWithText(ElevatedButton, 'Criar conta'), findsOneWidget);
    });

    testWidgets('Deve mostrar erro se tentar submeter formulário vazio', (tester) async {
      await loadPage(tester);
      
      // Tenta clicar no botão sem preencher nada
      // (Dependendo da implementação, o botão pode estar null/disabled ou clicar e mostrar erro)
      final nomeField = find.widgetWithText(TextFormField, 'Nome completo');
      await tester.enterText(nomeField, ''); 
      await tester.pump();

      // Clica em outro lugar para tirar o foco
      await tester.tap(find.text('Crie sua conta')); 
      await tester.pumpAndSettle();
      
      // Verifica se o botão está desabilitado (onPressed é null) quando inválido
      final button = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Criar conta'));
      expect(button.onPressed, isNull, reason: "O botão deve estar desabilitado se o form for inválido");
    });

    testWidgets('Deve habilitar o botão quando o formulário for válido', (tester) async {
      await loadPage(tester);

      // Preencher Nome
      await tester.enterText(find.widgetWithText(TextFormField, 'Nome completo'), 'Usuário Teste');
      
      // Preencher Email
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'teste@email.com');
      
      // Preencher Senha 
      await tester.enterText(find.widgetWithText(TextFormField, 'Senha'), 'SenhaForte123!');
      
      // Confirmar Senha
      await tester.enterText(find.widgetWithText(TextFormField, 'Confirmar senha'), 'SenhaForte123!');

      // Marcar Checkbox (Termos)
      // O find.byType(Checkbox) pode achar múltiplos se houver mais, mas aqui só tem um.
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Atualiza a tela para processar as mudanças de estado
      await tester.pumpAndSettle();

      // Verifica se o botão agora está habilitado (onPressed NÃO é null)
      final button = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Criar conta'));
      expect(button.onPressed, isNotNull, reason: "O botão deve habilitar com dados válidos");
    });
  });
}