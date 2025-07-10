abstract class RateableItem {
  String get token;
  String get img;
  String get name;
  int get price;
  String
  get displayInfo; // Para mostrar información específica (descripción o volumen)
  double get rate => 0.0; // Rating por defecto
}
