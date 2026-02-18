
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/register_controller.dart';
import 'package:mindease_focus/features/auth/domain/usecases/register_usecase.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late RegisterController controller;
  late MockRegisterUseCase mockRegisterUseCase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    controller = RegisterController(mockRegisterUseCase);
  });

  group('RegisterController', () {
    test('initial state should be correct', () {
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
      expect(controller.isFormValid, false);
    });

    test('updateFormValidity should update isFormValid correctly', () {
      controller.updateFormValidity(
        name: '',
        email: '',
        password: '',
        confirmPassword: '',
        acceptedTerms: false,
      );
      expect(controller.isFormValid, false);

      controller.updateFormValidity(
        name: 'Test User',
        email: 'test@test.com',
        password: 'Password123!',
        confirmPassword: 'Password123!',
        acceptedTerms: true,
      );
      expect(controller.isFormValid, true);
    });

    test('register success', () async {
      when(() => mockRegisterUseCase(
            name: 'Test User',
            email: 'test@test.com',
            password: 'Password123!',
          )).thenAnswer((_) async {});

      final future = controller.register(
        name: 'Test User',
        email: 'test@test.com',
        password: 'Password123!',
      );

      expect(controller.isLoading, true);
      await future;
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
      verify(() => mockRegisterUseCase(
            name: 'Test User',
            email: 'test@test.com',
            password: 'Password123!',
          )).called(1);
    });

    test('register failure', () async {
      when(() => mockRegisterUseCase(
            name: 'Test User',
            email: 'test@test.com',
            password: 'Password123!',
          )).thenAnswer((_) async => throw Exception('Registration failed'));

      final future = controller.register(
        name: 'Test User',
        email: 'test@test.com',
        password: 'Password123!',
      );

      expect(controller.isLoading, true);
      await future;
      expect(controller.isLoading, false);
      expect(controller.errorMessage, 'Registration failed');
      verify(() => mockRegisterUseCase(
            name: 'Test User',
            email: 'test@test.com',
            password: 'Password123!',
          )).called(1);
    });
  });
}
