import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository({
    fb.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Validar dominio @utem.cl
      if (!_isValidUtemEmail(googleUser.email)) {
        await _googleSignIn.signOut();
        throw Exception('Solo se permiten cuentas con dominio @utem.cl');
      }

      final googleAuth = await googleUser.authentication;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', googleAuth.idToken ?? '');

      debugPrint("TOKEN DIRECTO DE GOOGLE:");
      debugPrint(googleAuth.idToken ?? 'sin token');
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) return null;

      return _mapFirebaseUserToEntity(user);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserEntity?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      // Validar dominio @utem.cl
      if (!_isValidUtemEmail(email)) {
        throw Exception('Solo se permiten cuentas con dominio @utem.cl');
      }

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUserToEntity(userCredential.user);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserEntity?> registerWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      // Validar dominio @utem.cl
      if (!_isValidUtemEmail(email)) {
        throw Exception('Solo se permiten cuentas con dominio @utem.cl');
      }

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUserToEntity(userCredential.user);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Stream<UserEntity?> get userChanges {
    return _firebaseAuth.userChanges().map(_mapFirebaseUserToEntity);
  }

  @override
  Future<String?> getIdToken() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  UserEntity? _mapFirebaseUserToEntity(fb.User? user) {
    if (user == null) return null;
    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  bool _isValidUtemEmail(String email) {
    return email.toLowerCase().endsWith('@utem.cl');
  }
}
