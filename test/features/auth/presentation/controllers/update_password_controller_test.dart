
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/update_password_controller.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UpdatePasswordController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    controller = UpdatePasswordController(mockAuthRepository);
  });

  group('UpdatePasswordController', () {
    test('initial state should be correct', () {
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
    });

    test('updatePassword success', () async {
      when(() => mockAuthRepository.updateUserPassword('newPassword'))
          .thenAnswer((_) async {});
      when(() => mockAuthRepository.logoutUser())
          .thenAnswer((_) async {});

      final future = controller.updatePassword('newPassword');

      expect(controller.isLoading, true);
      await future;
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
      verify(() => mockAuthRepository.updateUserPassword('newPassword')).called(1);
      verify(() => mockAuthRepository.logoutUser()).called(1);
    });

    test('updatePassword failure at update step', () async {
      when(() => mockAuthRepository.updateUserPassword('newPassword'))
          .thenAnswer((_) async => throw Exception('Update failed'));

      final future = controller.updatePassword('newPassword');

      expect(controller.isLoading, true);
      await future;
      expect(controller.isLoading, false);
      expect(controller.errorMessage, 'Update failed');
      verify(() => mockAuthRepository.updateUserPassword('newPassword')).called(1);
      verifyNever(() => mockAuthRepository.logoutUser());
    });
  });
}
