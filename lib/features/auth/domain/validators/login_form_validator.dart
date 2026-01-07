import 'email_validator.dart';
import 'password_validator.dart';

class LoginFormValidator {
  static bool isValid({
    required String email,
    required String password,
  }) {
    return EmailValidator.validate(email) == null &&
        PasswordValidator.validate(password) == null;
  }
}
