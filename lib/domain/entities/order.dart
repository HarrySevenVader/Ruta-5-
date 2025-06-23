enum OrderStatus { pending, processing, completed, cancelled }

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double? discount;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.discount,
  });

  double get total => quantity * unitPrice - (discount ?? 0);
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final DateTime createdAt;
  final OrderStatus status;
  final String? deliveryAddress;
  final String? notes;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.status,
    this.deliveryAddress,
    this.notes,
  });

  double get total => items.fold(0, (sum, item) => sum + item.total);
}
