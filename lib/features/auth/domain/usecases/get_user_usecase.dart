import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository _repository;

  GetUserUseCase(this._repository);

  UserEntity call() {
    final User? supabaseUser = _repository.currentUser;

    if (supabaseUser == null) {
      return UserEntity.empty();
    }

    final String name = supabaseUser.userMetadata?['nome']?.toString() ?? 'Usuário MindEase';
    final String email = supabaseUser.email ?? 'Sem e-mail';

    return UserEntity(
      id: supabaseUser.id,
      email: email,
      name: name,
    );
  }
}