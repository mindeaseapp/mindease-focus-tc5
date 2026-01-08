import 'package:mindease_focus/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepository(this._dataSource);

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _dataSource.signUp(email: email, password: password, nome: name);
    } catch (e) {
      throw Exception('Erro no cadastro: $e');
    }
  }
}