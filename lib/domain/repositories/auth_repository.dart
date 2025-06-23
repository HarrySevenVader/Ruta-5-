import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  /// Inicia sesión con email y contraseña
  Future<Either<Failure, User>> login(String email, String password);

  /// Registra un nuevo usuario
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Cierra sesión
  Future<Either<Failure, void>> logout();

  /// Obtiene el usuario actual si está autenticado
  Future<Either<Failure, User?>> getCurrentUser();

  /// Verifica si hay una sesión activa
  Future<Either<Failure, bool>> isLoggedIn();
}
