// test/models/cart_item_test.dart
import 'package:test/test.dart';
import 'package:app_client/data/models/cart_item.dart';
import 'package:app_client/data/models/product.dart';

void main() {
  group('CartItem Model', () {
    test('should calculate total price correctly', () {
      final product = Product(
        name: 'Pizza',
        category: 'Food',
        ingredients: ['Tomato', 'Cheese'],
        price: 10.0,
        imagePath: 'path/to/image',
      );
      final cartItem = CartItem(
        product: product,
        quantity: 2,
        size: 'Grande',
        toppings: ['Queso extra'],
      );

      final totalPrice = cartItem.totalPrice;

      // El precio base es 10 * 2 = 20, el tamaño 'Grande' lo multiplica por 1.6 (20 * 1.6 = 32),
      // y el topping 'Queso extra' cuesta 0.5, entonces el total será 32 + 0.5 = 32.5
      expect(totalPrice, 32.5);
    });

    test('should serialize and deserialize CartItem', () {
      final product = Product(
        name: 'Pizza',
        category: 'Food',
        ingredients: ['Tomato', 'Cheese'],
        price: 10.0,
        imagePath: 'path/to/image',
      );
      final cartItem = CartItem(
        product: product,
        quantity: 2,
        size: 'Mediano',
        toppings: ['Salsa extra'],
      );

      final json = cartItem.toJson();
      final newCartItem = CartItem.fromJson(json);

      expect(newCartItem.product.name, 'Pizza');
      expect(newCartItem.quantity, 2);
      expect(newCartItem.size, 'Mediano');
      expect(newCartItem.toppings, ['Salsa extra']);
    });
  });
}
