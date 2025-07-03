import '../../domain/entities/dish_entity.dart';

class DishModel extends DishEntity {
  DishModel({
    required super.token,
    required super.img,
    required super.name,
    required super.description,
    required super.price,
    required super.rate,
  });

  factory DishModel.fromJson(Map<String, dynamic> json) {
    return DishModel(
      token: json['token'],
      img: json['img'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      rate: (json['rate'] as num).toDouble(),
    );
  }
}
