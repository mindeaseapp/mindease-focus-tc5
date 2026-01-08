import 'package:mindease_focus/features/auth/domain/validators/confirm_password_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/email_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/name_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/password_validator.dart';

class RegisterFormValidator {
  static bool isValid({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) {
    return NameValidator.validate(name) == null &&
        EmailValidator.validate(email) == null &&
        PasswordValidator.validate(password) == null &&
        ConfirmPasswordValidator.validate(
              password: password,
              confirmPassword: confirmPassword,
            ) ==
            null &&
        acceptedTerms;
  }
}
