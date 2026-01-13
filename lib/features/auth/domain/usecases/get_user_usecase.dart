import 'package:supabase_flutter/supabase_flutter.dart'; // Import necessário apenas para tipagem do retorno do repo atual
import 'package:mindease_focus/features/auth/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository _repository;

  GetUserUseCase(this._repository);

  UserEntity call() {
    // 1. Busca o usuário bruto do repositório
    final User? supabaseUser = _repository.currentUser;

    if (supabaseUser == null) {
      return UserEntity.empty();
    }

    // 2. APLICA A REGRA DE TRATAMENTO AQUI (A lógica sai do Controller)
    final String name = supabaseUser.userMetadata?['nome']?.toString() ?? 'Usuário MindEase';
    final String email = supabaseUser.email ?? 'Sem e-mail';

    // 3. Retorna o dado limpo para quem pediu
    return UserEntity(
      id: supabaseUser.id,
      email: email,
      name: name,
    );
  }
}