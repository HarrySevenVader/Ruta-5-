import 'rateable_item.dart';

class DrinkEntity implements RateableItem {
  final String token;
  final String img;
  final String name;
  final double volume;
  final String unit;
  final int price;

  DrinkEntity({
    required this.token,
    required this.img,
    required this.name,
    required this.volume,
    required this.unit,
    required this.price,
  });

  @override
  String get displayInfo => '$volume $unit';

  @override
  double get rate => 0.0; // Las bebidas empiezan sin calificación
}
