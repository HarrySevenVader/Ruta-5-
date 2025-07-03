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
    required super.dish,
    required super.drink,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      category: CategoryModel.fromJson(json['category']),
      dish: DishModel.fromJson(json['dishes']),
      drink: DrinkModel.fromJson(json['drinks']),
    );
  }
}
