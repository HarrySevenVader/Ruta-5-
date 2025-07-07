import '../../domain/entities/menu_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/dish_entity.dart';
import '../../domain/entities/drink_entity.dart';

import 'category_model.dart';
import 'dish_model.dart';
import 'drink_model.dart';

class MenuModel extends MenuEntity {
  MenuModel({
    required super.category,
    required super.dishes,
    required super.drinks,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      category: CategoryModel.fromJson(json['category']),
      dishes:
          (json['dishes'] as List<dynamic>?)
              ?.map((dish) => DishModel.fromJson(dish))
              .toList() ??
          [],
      drinks:
          (json['drinks'] as List<dynamic>?)
              ?.map((drink) => DrinkModel.fromJson(drink))
              .toList() ??
          [],
    );
  }
}
