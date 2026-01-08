import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

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
}