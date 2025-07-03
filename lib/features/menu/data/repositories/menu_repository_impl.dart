import '../../domain/entities/menu_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_api_datasource.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuApiDatasource datasource;

  MenuRepositoryImpl(this.datasource);

  @override
  Future<List<MenuEntity>> getTodayMenu() {
    return datasource.getTodayMenu();
  }
}
