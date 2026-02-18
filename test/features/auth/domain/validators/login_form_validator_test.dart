
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/domain/validators/login_form_validator.dart';

void main() {
  group('LoginFormValidator', () {
    test('should return false when email is invalid', () {
      final result = LoginFormValidator.isValid(
        email: 'invalid',
        password: 'Password123',
      );
      expect(result, false);
    });

    test('should return false when password is invalid', () {
      final result = LoginFormValidator.isValid(
        email: 'test@example.com',
        password: 'pass',
      );
      expect(result, false);
    });

    test('should return true when both are valid', () {
      final result = LoginFormValidator.isValid(
        email: 'test@example.com',
        password: 'Password123',
      );
      expect(result, true);
    });
  });
}
