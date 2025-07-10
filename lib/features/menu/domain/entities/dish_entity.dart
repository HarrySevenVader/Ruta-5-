import 'rateable_item.dart';

class DishEntity implements RateableItem {
  final String token;
  final String img;
  final String name;
  final String description;
  final int price;
  final double rate;

  DishEntity({
    required this.token,
    required this.img,
    required this.name,
    required this.description,
    required this.price,
    required this.rate,
  });

  @override
  String get displayInfo => description;
}
