import 'category_entity.dart';
import 'dish_entity.dart';
import 'drink_entity.dart';

class MenuEntity {
  final CategoryEntity category;
  final DishEntity dish;
  final DrinkEntity drink;

  MenuEntity({required this.category, required this.dish, required this.drink});
}
