import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInWithEmailPassword(String email, String password);
  Future<UserEntity?> registerWithEmailPassword(String email, String password);
  Future<void> signOut();
  Stream<UserEntity?> get userChanges;
  Future<String?> getIdToken();
}


// en esta capa se define que operaciones puede hacer la capa de dominio con la autenticacion, sin importar como estan implementadas
// la implementacion de firebase va en la data layer