class ServerException implements Exception {
  final String message;

  ServerException([this.message = "Error en el servidor"]);
}

class CacheException implements Exception {
  final String message;

  CacheException([this.message = "Error en el almacenamiento local"]);
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = "Error de conexión"]);
}

class AuthException implements Exception {
  final String message;

  AuthException([this.message = "Error de autenticación"]);
}
