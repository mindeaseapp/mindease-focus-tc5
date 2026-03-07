import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthRemoteDataSource(this._supabase);

  Future<void> signUp({
    required String email, 
    required String password, 
    required String nome
  }) async {
    final AuthResponse res = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'nome': nome}, 
    );

    if (res.user == null) {
      throw Exception('Erro ao criar usuário: Falha na autenticação.');
    }
  }

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    final AuthResponse res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (res.user == null) {
      throw Exception('Erro ao fazer login: Usuário nulo.');
    }
    return res.user!;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  Future<void> updatePassword(String newPassword) async {
    final UserResponse res = await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    if (res.user == null) {
      throw Exception('Erro ao atualizar a senha.');
    }
  }

  Future<void> resetPasswordForEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
      );
    } catch (e) {
      throw Exception('Erro ao solicitar recuperação de senha: ${e.toString()}');
    }
  }
}