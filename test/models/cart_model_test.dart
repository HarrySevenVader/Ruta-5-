// test/models/cart_model_test.dart
import 'package:test/test.dart';
import 'package:app_client/data/models/cart_item.dart';
import 'package:app_client/data/models/cart_model.dart';
import 'package:app_client/data/models/product.dart';

void main() {
  group('CartModel', () {
    test('should add items to the cart', () {
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
        toppings: ['Salsa extra'],
      );

      final cart = CartModel();

      // Adding the first item
      final added = cart.add(cartItem);
      expect(added, true);
      expect(cart.items.length, 1);

      // Adding the same item again
      final addedAgain = cart.add(cartItem);
      expect(addedAgain, true);
      expect(cart.items[0].quantity, 4); // The quantity should increase
    });

    test('should prevent adding more than available stock', () {
      final product = Product(
        name: 'Pizza',
        category: 'Food',
        ingredients: ['Tomato', 'Cheese'],
        price: 10.0,
        imagePath: 'path/to/image',
        stock: 5,
      );

      final cartItem = CartItem(
        product: product,
        quantity: 6, // Trying to add more than available stock
        size: 'Grande',
        toppings: ['Salsa extra'],
      );

      final cart = CartModel();
      final added = cart.add(cartItem);

      expect(
        added,
        false,
      ); // It should not be added because it's over the stock limit
    });
  });
}
