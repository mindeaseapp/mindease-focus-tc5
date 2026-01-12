import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/features/auth/data/datasources/auth_remote_datasource.dart';

class ResetPasswordController extends ChangeNotifier {
  // Injeção de dependência simples
  final AuthRepository _repository = AuthRepository(AuthRemoteDataSource());

  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;

  Future<void> sendResetLink(String email) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
    notifyListeners();

    try {
      await _repository.sendPasswordResetEmail(email);
      isSuccess = true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  // Reseta o estado ao sair da tela
  void resetState() {
    isSuccess = false;
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}