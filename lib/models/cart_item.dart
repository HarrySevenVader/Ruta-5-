import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final String? size;
  final List<String> toppings;

  CartItem({
    required this.product,
    required this.quantity,
    this.size,
    this.toppings = const [],
  });

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
          toppingsCost += 1500;
          break;
        case 'Tocino':
          toppingsCost += 2000;
          break;
        case 'Champiñones':
          toppingsCost += 1000;
          break;
        case 'Palta':
          toppingsCost += 1500;
          break;
        case 'Huevo frito':
          toppingsCost += 2000;
          break;
      }
    }
    return price + (toppingsCost * quantity);
  }
}
