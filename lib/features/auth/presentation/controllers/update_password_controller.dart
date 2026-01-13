import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/features/auth/data/datasources/auth_remote_datasource.dart';

class UpdatePasswordController extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository(AuthRemoteDataSource());

  bool isLoading = false;
  String? errorMessage;

  Future<bool> updatePassword(String newPassword) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 1. Atualiza a senha no Supabase
      await _repository.updateUserPassword(newPassword);

      // 2. LOGOUT FORÇADO (Sua regra de segurança)
      // Isso garante que a sessão do link mágico seja destruída
      await _repository.logoutUser();

      isLoading = false;
      notifyListeners();
      return true; // Sucesso
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}