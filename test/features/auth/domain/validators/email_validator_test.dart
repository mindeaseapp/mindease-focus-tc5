
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/domain/validators/email_validator.dart';

void main() {
  group('EmailValidator', () {
    test('should return error message when email is empty', () {
      expect(EmailValidator.validate(''), 'Informe seu email');
      expect(EmailValidator.validate(null), 'Informe seu email');
    });

    test('should return error message when email is invalid', () {
      expect(EmailValidator.validate('invalid-email'), 'Digite um email válido (ex: nome@email.com)');
      expect(EmailValidator.validate('user@'), 'Digite um email válido (ex: nome@email.com)');
      expect(EmailValidator.validate('user@domain'), 'Digite um email válido (ex: nome@email.com)');
      expect(EmailValidator.validate('@domain.com'), 'Digite um email válido (ex: nome@email.com)');
    });

    test('should return null when email is valid', () {
      expect(EmailValidator.validate('test@example.com'), null);
      expect(EmailValidator.validate('user.name@domain.co.uk'), null);
    });
  });
}
