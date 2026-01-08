import 'package:mindease_focus/features/auth/domain/validators/email_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/password_validator.dart';

class LoginFormValidator {
  static bool isValid({
    required String email,
    required String password,
  }) {
    return EmailValidator.validate(email) == null &&
        PasswordValidator.validate(password) == null;
  }
}
