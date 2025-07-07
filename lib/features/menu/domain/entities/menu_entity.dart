import 'category_entity.dart';
import 'dish_entity.dart';
import 'drink_entity.dart';

class MenuEntity {
  final CategoryEntity category;
  final List<DishEntity> dishes;
  final List<DrinkEntity> drinks;

  MenuEntity({
    required this.category,
    required this.dishes,
    required this.drinks,
  });
}
