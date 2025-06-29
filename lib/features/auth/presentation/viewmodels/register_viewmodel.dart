import 'package:flutter/material.dart';

import '../../domain/usecases/register_with_email_password.dart';
import '../../domain/entities/user_entity.dart';

class RegisterViewModel extends ChangeNotifier {
  final RegisterWithEmailPassword _registerWithEmailPassword;

  UserEntity? user;
  String? errorMessage;
  bool isLoading = false;

  RegisterViewModel(this._registerWithEmailPassword);

  Future<void> register(String email, String password) async {
    _setLoading(true);
    try {
      user = await _registerWithEmailPassword(email, password);
      errorMessage = user == null ? 'No se pudo registrar' : null;
    } catch (_) {
      errorMessage = 'Error al registrar usuario';
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
