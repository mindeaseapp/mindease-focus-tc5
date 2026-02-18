
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/domain/validators/password_validator.dart';

void main() {
  group('PasswordValidator', () {
    test('should return error message when password is empty', () {
      expect(PasswordValidator.validate(''), 'Informe sua senha');
      expect(PasswordValidator.validate(null), 'Informe sua senha');
    });

    test('should return error message when password is too short', () {
      expect(PasswordValidator.validate('Pass1'), 'A senha deve ter no mínimo 8 caracteres');
    });

    test('should return error message when password has no uppercase letter', () {
      expect(PasswordValidator.validate('password123'), 'Inclua pelo menos uma letra maiúscula');
    });

    test('should return error message when password has no lowercase letter', () {
      expect(PasswordValidator.validate('PASSWORD123'), 'Inclua pelo menos uma letra minúscula');
    });

    test('should return error message when password has no number', () {
      expect(PasswordValidator.validate('Password'), 'Inclua pelo menos um número');
    });

    test('should return null when password is valid', () {
      expect(PasswordValidator.validate('Password123'), null);
      expect(PasswordValidator.validate('SecureP@ss1'), null);
    });
  });
}
