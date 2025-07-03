import '../entities/menu_entity.dart';
import '../repositories/menu_repository.dart';

class GetTodayMenu {
  final MenuRepository repository;

  GetTodayMenu(this.repository);

  Future<List<MenuEntity>> call() {
    return repository.getTodayMenu();
  }
}
