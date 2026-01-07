class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe sua senha';
    }
    if (value.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Inclua pelo menos uma letra maiúscula';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Inclua pelo menos uma letra minúscula';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Inclua pelo menos um número';
    }
    return null;
  }
}
