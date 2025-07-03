import 'package:flutter/material.dart';

import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_in_with_email_password.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_id_token.dart';

class LoginViewModel extends ChangeNotifier {
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithEmailPassword _signInWithEmailPassword;
  final GetIdToken _getIdToken;

  UserEntity? user;
  String? errorMessage;
  bool isLoading = false;
  String? idToken;

  LoginViewModel({
    required SignInWithGoogle signInWithGoogle,
    required SignInWithEmailPassword signInWithEmailPassword,
    required GetIdToken getIdToken,
  }) : _signInWithGoogle = signInWithGoogle,
       _signInWithEmailPassword = signInWithEmailPassword,
       _getIdToken = getIdToken;

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

  Future<String?> getIdToken() async {
    idToken = await _getIdToken();
    return idToken;
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
