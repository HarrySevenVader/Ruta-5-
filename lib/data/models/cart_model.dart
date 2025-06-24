import 'cart_item.dart';

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
  bool _listsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (var item in list1) {
      if (!list2.contains(item)) return false;
    }
    return true;
  }

  // Métodos de serialización y deserialización
  Map<String, dynamic> toJson() {
    return {'items': _items.map((item) => item.toJson()).toList()};
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final cartModel = CartModel();
    if (json['items'] != null) {
      cartModel._items.addAll(
        (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      );
    }
    return cartModel;
  }
}
