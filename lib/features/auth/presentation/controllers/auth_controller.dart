import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final GetUserUseCase _getUserUseCase;
  final AuthRepository _authRepository;
  
  late final StreamSubscription<AuthState> _authSubscription;
  UserEntity _user = UserEntity.empty();
  
  bool get isAuthenticated => _user.id.isNotEmpty;
  UserEntity get user => _user;

  bool _needsPasswordReset = false;
  bool get needsPasswordReset => _needsPasswordReset;

  void resetPasswordResetFlag() {
    _needsPasswordReset = false;
    notifyListeners();
  }

  AuthController({
    required GetUserUseCase getUserUseCase,
    required AuthRepository authRepository,
    required SupabaseClient supabaseClient,
  })  : _getUserUseCase = getUserUseCase,
        _authRepository = authRepository {
    _loadCurrentUser();
    _authSubscription = supabaseClient.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        _needsPasswordReset = true;
        notifyListeners();
      }
      _loadCurrentUser();
    });
  }

  void _loadCurrentUser() {
    // O Controller não sabe de onde vem, nem como trata o nome. Só pede.
    _user = _getUserUseCase();
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logoutUser();
    
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