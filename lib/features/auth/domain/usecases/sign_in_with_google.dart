import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<UserEntity?> call() {
    return repository.signInWithGoogle();
  }
}

// un caso de uso es una accion concreta de negocio, en este caso este inicia sesion con google
// el caso de uso recibe el repositorio y lo ejecuta con call