class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Digite um email válido (ex: nome@email.com)';
    }

    return null;
  }
}
