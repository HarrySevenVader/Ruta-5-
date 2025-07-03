import 'package:flutter/material.dart';
import '../../domain/entities/menu_entity.dart';
import '../../domain/usecases/get_today_menu.dart';

class MenuViewModel extends ChangeNotifier {
  final GetTodayMenu _getTodayMenu;

  MenuViewModel(this._getTodayMenu);

  List<MenuEntity> _menus = [];
  String? _error;
  bool _isLoading = false;

  List<MenuEntity> get menus => _menus;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> fetchMenu() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _menus = await _getTodayMenu();
    } catch (e) {
      _error = 'Error al cargar el menú.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
