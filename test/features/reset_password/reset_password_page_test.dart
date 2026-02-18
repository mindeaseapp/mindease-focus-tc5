import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (email == 'error@teste.com') {
      throw Exception('Erro de rede simulado');
    }
    return;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://fake-url.com',
      anonKey: 'fake-anon-key',
    );
  });

  late ResetPasswordController controller;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    controller = ResetPasswordController(mockRepo);
  });

  group('ResetPasswordController Tests', () {
    
    test('Deve iniciar com os estados padrão (limpos)', () {
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
    });

    test('Fluxo resetPassword: Deve gerenciar o estado corretamente', () async {
      // 1. Tenta enviar
      final future = controller.resetPassword('email@teste.com');
      
      // 2. Verifica se entrou em loading
      expect(controller.isLoading, true);

      // 3. Espera acabar
      await future;

      // 4. Verifica se saiu do loading
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
    });

    test('Fluxo resetPassword: Deve capturar erro corretamente', () async {
      await controller.resetPassword('error@teste.com');
      
      expect(controller.isLoading, false);
      expect(controller.errorMessage, isNotNull);
      expect(controller.errorMessage, contains('Erro de rede simulado'));
    });
  });
}