import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterWithEmailPassword {
  final AuthRepository repository;

  RegisterWithEmailPassword(this.repository);

  Future<UserEntity?> call(String email, String password) {
    return repository.registerWithEmailPassword(email, password);
  }
}
