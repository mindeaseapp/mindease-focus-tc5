import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/domain/usecases/login_usecase.dart';
import 'package:mindease_focus/features/auth/domain/validators/login_form_validator.dart';

class LoginController extends ChangeNotifier {
  final LoginUseCase _loginUseCase;

  LoginController(this._loginUseCase);

  bool isLoading = false;
  String? errorMessage;
  bool isFormValid = false;

  void updateFormValidity({
    required String email,
    required String password,
  }) {
    final isValid = LoginFormValidator.isValid(
      email: email,
      password: password,
    );

    if (isValid != isFormValid) {
      isFormValid = isValid;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _loginUseCase(email: email, password: password);
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