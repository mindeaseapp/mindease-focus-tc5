import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthController extends ChangeNotifier {
  // Em um projeto real com injeção de dependência (GetIt/Modular), isso viria no construtor
  final GetUserUseCase _getUserUseCase = GetUserUseCase(
    AuthRepository(AuthRemoteDataSource()),
  );
  
  late final StreamSubscription<AuthState> _authSubscription;
  // Agora guardamos a Entidade, não o objeto do Supabase
  UserEntity _user = UserEntity.empty();
  
  UserEntity get user => _user;
  bool get isAuthenticated => _user.id.isNotEmpty;

  AuthController() {
    _loadCurrentUser();
    // 2. ESCUTA ATIVA: Qualquer mudança no Supabase (Login, Logout, Link Mágico)
    // atualiza automaticamente o nosso Controller
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      _loadCurrentUser();
    });
  }

  void _loadCurrentUser() {
    // O Controller não sabe de onde vem, nem como trata o nome. Só pede.
    _user = _getUserUseCase();
    notifyListeners();
  }

  Future<void> logout() async {
    // Idealmente teria um LogoutUseCase também, mas vamos focar no GetUser
    final repo = AuthRepository(AuthRemoteDataSource());
    await repo.logoutUser();
    
    _user = UserEntity.empty();
    notifyListeners();
  }
  
  void refreshUser() {
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _authSubscription.cancel(); // Boa prática: cancelar o listener ao destruir
    super.dispose();
  }
}