import 'product.dart';

class CartItem {
  final Product product;
  int quantity; // Modificado: ya no es final para permitir aumentar cantidad
  final String? size;
  final List<String> toppings;

  CartItem({
    required this.product,
    required this.quantity,
    this.size,
    this.toppings = const [],
  });

  // Método para crear un CartItem vacío
  static CartItem empty() {
    return CartItem(product: Product.empty(), quantity: 0);
  }

  // Para verificar si está vacío
  bool get isEmpty => quantity == 0 || product.name.isEmpty;

  double get totalPrice {
    double price = product.price * quantity;
    if (size == 'Mediano') {
      price *= 1.3;
    } else if (size == 'Grande') {
      price *= 1.6;
    }
    double toppingsCost = 0.0;
    for (final t in toppings) {
      switch (t) {
        case 'Queso extra':
          toppingsCost += 0.5;
          break;
        case 'Salsa extra':
          toppingsCost += 0.3;
          break;
        // Puedes agregar más casos si lo deseas
      }
    }
    return price + toppingsCost;
  }

  // Serialización y deserialización
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      size: json['size'],
      toppings: List<String>.from(json['toppings'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'size': size,
      'toppings': toppings,
    };
  }
}
