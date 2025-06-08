import 'cart_item.dart';

class CartModel {
  static final CartModel _instance = CartModel._internal();
  factory CartModel() => _instance;
  CartModel._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void add(CartItem item) {
    _items.add(item);
  }

  void clear() {
    _items.clear();
  }
}
