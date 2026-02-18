import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/domain/usecases/register_usecase.dart';
import 'package:mindease_focus/features/auth/domain/validators/register_form_validator.dart';

class RegisterController extends ChangeNotifier {
  final RegisterUseCase _registerUseCase;

  RegisterController(this._registerUseCase);

  bool isLoading = false;
  String? errorMessage;
  bool isFormValid = false;

  void updateFormValidity({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) {
    final isValid = RegisterFormValidator.isValid(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      acceptedTerms: acceptedTerms,
    );

    if (isValid != isFormValid) {
      isFormValid = isValid;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _registerUseCase(
        name: name,
        email: email,
        password: password,
      );
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