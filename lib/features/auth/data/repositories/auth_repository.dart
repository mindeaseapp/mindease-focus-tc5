import 'package:supabase_flutter/supabase_flutter.dart';
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

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _dataSource.signIn(email: email, password: password);
    } catch (e) {
      throw Exception('Erro no login: $e');
    }
  }

  Future<void> logoutUser() async {
    await _dataSource.signOut();
  }

  Future<void> updateUserPassword(String newPassword) async {
    try {
      await _dataSource.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Erro na atualização de senha: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Erro no envio do email: $e');
    }
  }

  User? get currentUser => _dataSource.getCurrentUser();
}