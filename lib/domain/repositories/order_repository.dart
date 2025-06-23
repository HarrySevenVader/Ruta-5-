import 'package:dartz/dartz.dart';
import '../entities/order.dart' as entities;
import '../../core/errors/failures.dart';

abstract class OrderRepository {
  /// Obtiene todas las órdenes del usuario actual
  Future<Either<Failure, List<entities.Order>>> getUserOrders();

  /// Obtiene una orden por ID
  Future<Either<Failure, entities.Order>> getOrderById(String id);

  /// Crea una nueva orden
  Future<Either<Failure, entities.Order>> createOrder({
    required List<entities.OrderItem> items,
    String? deliveryAddress,
    String? notes,
    String? tableNumber,
    bool isDelivery,
  });

  /// Actualiza el estado de una orden
  Future<Either<Failure, entities.Order>> updateOrderStatus(
    String orderId,
    entities.OrderStatus status,
  );

  /// Cancela una orden
  Future<Either<Failure, void>> cancelOrder(String orderId);

  /// Obtiene el estado actual de una orden
  Future<Either<Failure, entities.OrderStatus>> getOrderStatus(String orderId);
}
