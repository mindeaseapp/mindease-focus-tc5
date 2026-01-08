class PasswordValidator {
  static final RegExp _hasUppercase = RegExp(r'[A-Z]');
  static final RegExp _hasLowercase = RegExp(r'[a-z]');
  static final RegExp _hasNumber = RegExp(r'\d');

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe sua senha';
    }

    if (value.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres';
    }

    if (!_hasUppercase.hasMatch(value)) {
      return 'Inclua pelo menos uma letra maiúscula';
    }

    if (!_hasLowercase.hasMatch(value)) {
      return 'Inclua pelo menos uma letra minúscula';
    }

    if (!_hasNumber.hasMatch(value)) {
      return 'Inclua pelo menos um número';
    }

    return null;
  }
}
