import 'cart_item.dart';
import 'product.dart';

class CartModel {
  static final CartModel _instance = CartModel._internal();
  factory CartModel() => _instance;
  CartModel._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool add(CartItem item) {
    // Buscar si el producto con mismos detalles ya existe
    final existing = _items.firstWhere(
      (i) =>
          i.product.name == item.product.name &&
          i.size == item.size &&
          _listsEqual(i.toppings, item.toppings),
      orElse: () => CartItem.empty(),
    );

    int currentQty = existing.isEmpty ? 0 : existing.quantity;
    int availableStock = item.product.stock;

    if (currentQty + item.quantity > availableStock) {
      return false; // no se puede agregar más
    }

    if (existing.isEmpty) {
      _items.add(item);
    } else {
      existing.quantity += item.quantity;
    }
    return true;
  }

  // Comparar listas sin importar orden
  bool _listsEqual(List<String> a, List<String> b) {
    return Set<String>.from(a).containsAll(b) &&
        Set<String>.from(b).containsAll(a);
  }

  // Obtener cantidad total de un producto (independiente del tamaño/toppings)
  int getQuantity(Product product) {
    return _items
        .where((item) => item.product.name == product.name)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  void clear() {
    _items.clear();
  }

  void removeItemAt(int index) {
    _items.removeAt(index);
  }

  bool get isEmpty => _items.isEmpty;

  double getTotalPrice() {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }
}
