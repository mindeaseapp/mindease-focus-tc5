import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<void> call({
    required String email,
    required String password,
  }) async {
    await _repository.loginUser(email: email, password: password);
  }
}
