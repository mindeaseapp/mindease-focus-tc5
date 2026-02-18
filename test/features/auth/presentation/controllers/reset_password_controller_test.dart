
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ResetPasswordController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    controller = ResetPasswordController(mockAuthRepository);
  });

  group('ResetPasswordController', () {
    test('initial state should be correct', () {
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
    });

    test('resetPassword success', () async {
      when(() => mockAuthRepository.sendPasswordResetEmail('test@test.com'))
          .thenAnswer((_) async {});

      final future = controller.resetPassword('test@test.com');

      expect(controller.isLoading, true);
      await future;
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
      verify(() => mockAuthRepository.sendPasswordResetEmail('test@test.com')).called(1);
    });

    test('resetPassword failure', () async {
      when(() => mockAuthRepository.sendPasswordResetEmail('test@test.com'))
          .thenAnswer((_) async => throw Exception('Reset failed'));

      final future = controller.resetPassword('test@test.com');

      expect(controller.isLoading, true);
      await future;
      expect(controller.isLoading, false);
      expect(controller.errorMessage, 'Reset failed');
      verify(() => mockAuthRepository.sendPasswordResetEmail('test@test.com')).called(1);
    });
  });
}
