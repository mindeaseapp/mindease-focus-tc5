import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/features/auth/data/datasources/auth_remote_datasource.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository(AuthRemoteDataSource());

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.loginUser(email: email, password: password);
      isLoading = false;
      notifyListeners();
      return true; 
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}