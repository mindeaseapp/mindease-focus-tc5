
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/domain/validators/register_form_validator.dart';

void main() {
  group('RegisterFormValidator', () {
    const validName = 'Test User';
    const validEmail = 'test@example.com';
    const validPassword = 'Password123';
    
    test('should return false when name is invalid', () {
      final result = RegisterFormValidator.isValid(
        name: '',
        email: validEmail,
        password: validPassword,
        confirmPassword: validPassword,
        acceptedTerms: true,
      );
      expect(result, false);
    });

    test('should return false when email is invalid', () {
      final result = RegisterFormValidator.isValid(
        name: validName,
        email: 'invalid',
        password: validPassword,
        confirmPassword: validPassword,
        acceptedTerms: true,
      );
      expect(result, false);
    });

    test('should return false when password is invalid', () {
      final result = RegisterFormValidator.isValid(
        name: validName,
        email: validEmail,
        password: 'pass',
        confirmPassword: 'pass',
        acceptedTerms: true,
      );
      expect(result, false);
    });

    test('should return false when passwords do not match', () {
      final result = RegisterFormValidator.isValid(
        name: validName,
        email: validEmail,
        password: validPassword,
        confirmPassword: 'DifferentPassword123',
        acceptedTerms: true,
      );
      expect(result, false);
    });

    test('should return false when terms are not accepted', () {
      final result = RegisterFormValidator.isValid(
        name: validName,
        email: validEmail,
        password: validPassword,
        confirmPassword: validPassword,
        acceptedTerms: false,
      );
      expect(result, false);
    });

    test('should return true when form is valid', () {
      final result = RegisterFormValidator.isValid(
        name: validName,
        email: validEmail,
        password: validPassword,
        confirmPassword: validPassword,
        acceptedTerms: true,
      );
      expect(result, true);
    });
  });
}
