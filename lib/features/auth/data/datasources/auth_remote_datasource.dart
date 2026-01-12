import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Cadastro
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

  // --- Login ---
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

  // --- Logout ---
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // --- Usuário Atual ---
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // --- NOVO: Atualizar Senha ---
  Future<void> updatePassword(String newPassword) async {
    // O usuário JÁ estará com sessão válida (o link mágico fez isso ao abrir o app)
    final UserResponse res = await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    if (res.user == null) {
      throw Exception('Erro ao atualizar a senha.');
    }
  }

  Future<void> resetPasswordForEmail(String email) async {
    try {
      // O Supabase enviará um email com um link mágico para o usuário
      await _supabase.auth.resetPasswordForEmail(
        email,
        // redirectTo: 'io.mindease.app://reset-callback/', // Opcional: Configurar se usar Deep Link
      );
    } catch (e) {
      throw Exception('Erro ao solicitar recuperação de senha: ${e.toString()}');
    }
  }
}