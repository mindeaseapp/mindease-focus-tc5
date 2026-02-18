import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) async {
    // Aqui poderiam entrar regras de negócio complexas antes de chamar o repo
    await _repository.registerUser(
      name: name,
      email: email,
      password: password,
    );
  }
}
