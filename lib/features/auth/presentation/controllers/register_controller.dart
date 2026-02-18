import 'package:flutter/material.dart';
// CORREÇÃO: Usando caminhos completos para Repositório e DataSource
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class RegisterController extends ChangeNotifier {
  final AuthRepository _repository;

  RegisterController(this._repository);

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.registerUser(
        name: name,
        email: email,
        password: password,
      );
      isLoading = false;
      notifyListeners();
      return true; // Sucesso
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false; // Falha
    }
  }
}