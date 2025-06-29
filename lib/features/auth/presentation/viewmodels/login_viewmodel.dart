import 'package:flutter/material.dart';

import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_in_with_email_password.dart';
import '../../domain/entities/user_entity.dart';

class LoginViewModel extends ChangeNotifier {
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithEmailPassword _signInWithEmailPassword;

  UserEntity? user;
  String? errorMessage;
  bool isLoading = false;

  LoginViewModel({
    required SignInWithGoogle signInWithGoogle,
    required SignInWithEmailPassword signInWithEmailPassword,
  })  : _signInWithGoogle = signInWithGoogle,
        _signInWithEmailPassword = signInWithEmailPassword;

  Future<void> loginWithGoogle() async {
    _setLoading(true);
    try {
      user = await _signInWithGoogle();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error al iniciar sesión con Google.';
    }
    _setLoading(false);
  }

  Future<void> loginWithEmailPassword(String email, String password) async {
    _setLoading(true);
    try {
      user = await _signInWithEmailPassword(email, password);
      errorMessage = user == null ? 'Credenciales inválidas' : null;
    } catch (e) {
      errorMessage = 'Error al iniciar sesión con correo.';
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}