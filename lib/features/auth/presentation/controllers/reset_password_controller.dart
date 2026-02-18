import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

class ResetPasswordController extends ChangeNotifier {
  final AuthRepository _repository;

  ResetPasswordController(this._repository);

  bool isLoading = false;
  String? errorMessage;

  Future<bool> resetPassword(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.sendPasswordResetEmail(email);
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