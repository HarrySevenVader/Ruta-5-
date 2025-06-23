abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = "Error en el servidor"]) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure([String message = "Error en el almacenamiento local"])
    : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = "Error de conexión"]) : super(message);
}

class AuthFailure extends Failure {
  AuthFailure([String message = "Error de autenticación"]) : super(message);
}
