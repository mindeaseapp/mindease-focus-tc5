class ConfirmPasswordValidator {
  static String? validate({
    required String password,
    required String confirmPassword,
  }) {
    if (confirmPassword.isEmpty) {
      return 'Confirme sua senha';
    }
    if (password != confirmPassword) {
      return 'As senhas não coincidem';
    }
    return null;
  }
}
