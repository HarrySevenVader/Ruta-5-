import '../repositories/auth_repository.dart';

class GetIdToken {
  final AuthRepository repository;

  GetIdToken(this.repository);

  Future<String?> call() {
    return repository.getIdToken();
  }
}
