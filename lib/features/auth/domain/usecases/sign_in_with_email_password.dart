import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailPassword {
  final AuthRepository repository;

  SignInWithEmailPassword(this.repository);

  Future<UserEntity?> call(String email, String password) {
    return repository.signInWithEmailPassword(email, password);
  }
}
