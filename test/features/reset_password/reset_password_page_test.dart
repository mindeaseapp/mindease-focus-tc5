import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Necessário para o Supabase não quebrar
import 'package:supabase_flutter/supabase_flutter.dart'; // Necessário para inicializar
import 'package:mindease_focus/features/auth/presentation/controllers/reset_password_controller.dart';

void main() {
  // Garante que os plugins funcionam no teste
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // 1. Simula o SharedPreferences (O Supabase precisa disso para guardar sessão)
    SharedPreferences.setMockInitialValues({});

    // 2. Inicializa o Supabase com dados FALSOS só para parar o erro de "instance not initialized"
    // Não te preocupes com a URL, o teste vai falhar na rede e cair no catch do teu controller, que é o que queremos.
    await Supabase.initialize(
      url: 'https://fake-url.com',
      anonKey: 'fake-anon-key',
    );
  });

  late ResetPasswordController controller;

  setUp(() {
    controller = ResetPasswordController();
  });

  group('ResetPasswordController Tests (Sem Mock)', () {
    
    test('Deve iniciar com os estados padrão (limpos)', () {
      expect(controller.isLoading, false);
      expect(controller.isSuccess, false);
      expect(controller.errorMessage, null);
    });

    test('Deve resetar o estado corretamente ao chamar resetState', () {
      controller.isLoading = true;
      controller.isSuccess = true;
      controller.errorMessage = 'Erro antigo';

      controller.resetState();

      expect(controller.isLoading, false);
      expect(controller.isSuccess, false);
      expect(controller.errorMessage, null);
    });

    test('Fluxo sendResetLink: Deve gerenciar o estado e não quebrar', () async {
      // 1. Tenta enviar
      final future = controller.sendResetLink('email@teste.com');
      
      // 2. Verifica se entrou em loading
      expect(controller.isLoading, true);

      // 3. Espera acabar (vai dar erro de rede porque a URL do supabase é falsa)
      await future;

      // 4. Verifica se saiu do loading
      expect(controller.isLoading, false);

      // 5. O teste PASSA se tiver dado Sucesso OU se tiver capturado o erro.
      // Como a URL é falsa, vai cair no erro, a controller vai preencher o errorMessage, e o teste vai passar.
      final funcionouOuTratouErro = controller.isSuccess || controller.errorMessage != null;
      
      expect(funcionouOuTratouErro, true, reason: 'Deve ter dado sucesso ou capturado o erro de rede');
    });
  });
}