class EmailValidator {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu email';
    }

    final email = value.trim();

    if (!_emailRegex.hasMatch(email)) {
      return 'Digite um email válido (ex: nome@email.com)';
    }

    return null;
  }
}
