
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/login_controller.dart';
import 'package:mindease_focus/features/auth/domain/usecases/login_usecase.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginController controller;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    controller = LoginController(mockLoginUseCase);
  });

  group('LoginController', () {
    test('initial state should be correct', () {
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
      expect(controller.isFormValid, false);
    });

    test('updateFormValidity should update isFormValid correctly', () {
      controller.updateFormValidity(email: '', password: '');
      expect(controller.isFormValid, false);

      controller.updateFormValidity(email: 'test@test.com', password: 'Password123!');
      expect(controller.isFormValid, true);
    });

    test('login success', () async {
      when(() => mockLoginUseCase(email: 'test@test.com', password: 'Password123!'))
          .thenAnswer((_) async {});

      final future = controller.login(email: 'test@test.com', password: 'Password123!');
      
      expect(controller.isLoading, true);
      await future;
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
      verify(() => mockLoginUseCase(email: 'test@test.com', password: 'Password123!')).called(1);
    });

    test('login failure', () async {
      when(() => mockLoginUseCase(email: 'test@test.com', password: 'Password123!'))
          .thenAnswer((_) async => throw Exception('Login failed'));

      final future = controller.login(email: 'test@test.com', password: 'Password123!');
      
      expect(controller.isLoading, true);
      await future;
      expect(controller.isLoading, false);
      expect(controller.errorMessage, 'Login failed');
      verify(() => mockLoginUseCase(email: 'test@test.com', password: 'Password123!')).called(1);
    });
  });
}
