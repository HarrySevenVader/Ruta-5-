import '../../domain/entities/drink_entity.dart';

class DrinkModel extends DrinkEntity {
  DrinkModel({
    required super.token,
    required super.img,
    required super.name,
    required super.volume,
    required super.unit,
    required super.price,
  });

  factory DrinkModel.fromJson(Map<String, dynamic> json) {
    return DrinkModel(
      token: json['token'],
      img: json['img'],
      name: json['name'],
      volume: (json['volume'] as num).toDouble(),
      unit: json['unit'],
      price: json['price'],
    );
  }
}
