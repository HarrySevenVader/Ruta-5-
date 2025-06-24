// test/models/product_test.dart
import 'package:test/test.dart';
import 'package:app_client/data/models/product.dart';  // Ajusta la ruta según tu estructura

void main() {
  group('Product Model', () {
    test('should create a product from JSON', () {
      final json = {
        'name': 'Pizza',
        'category': 'Food',
        'ingredients': ['Tomato', 'Cheese'],
        'price': 10.0,
        'imagePath': 'path/to/image',
        'isAvailable': true,
        'stock': 20,
      };

      final product = Product.fromJson(json);

      expect(product.name, 'Pizza');
      expect(product.category, 'Food');
      expect(product.ingredients, ['Tomato', 'Cheese']);
      expect(product.price, 10.0);
      expect(product.imagePath, 'path/to/image');
      expect(product.isAvailable, true);
      expect(product.stock, 20);
    });

    test('should convert a product to JSON', () {
      final product = Product(
        name: 'Pizza',
        category: 'Food',
        ingredients: ['Tomato', 'Cheese'],
        price: 10.0,
        imagePath: 'path/to/image',
      );

      final json = product.toJson();

      expect(json['name'], 'Pizza');
      expect(json['category'], 'Food');
      expect(json['ingredients'], ['Tomato', 'Cheese']);
      expect(json['price'], 10.0);
      expect(json['imagePath'], 'path/to/image');
      expect(json['isAvailable'], true);
      expect(json['stock'], 15);  // El valor predeterminado
    });

    test('should create an empty product', () {
      final product = Product.empty();

      expect(product.name, '');
      expect(product.category, '');
      expect(product.ingredients, []);
      expect(product.price, 0);
      expect(product.imagePath, '');
      expect(product.isAvailable, false);
      expect(product.stock, 0);
    });
  });
}
