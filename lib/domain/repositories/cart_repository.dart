import 'package:dartz/dartz.dart';
import '../entities/cart.dart';
import '../entities/product.dart';
import '../../core/errors/failures.dart';

abstract class CartRepository {
  /// Obtiene el carrito actual
  Future<Either<Failure, Cart>> getCart();

  /// Añade un producto al carrito
  Future<Either<Failure, Cart>> addToCart({
    required Product product,
    int quantity = 1,
    String? size,
    List<String> toppings = const [],
  });

  /// Elimina un producto del carrito
  Future<Either<Failure, Cart>> removeFromCart(int index);

  /// Actualiza la cantidad de un producto en el carrito
  Future<Either<Failure, Cart>> updateQuantity(int index, int quantity);

  /// Vacía el carrito
  Future<Either<Failure, void>> clearCart();

  /// Obtiene el precio total del carrito
  Future<Either<Failure, double>> getTotalPrice();

  /// Verifica si el carrito está vacío
  Future<Either<Failure, bool>> isEmpty();

  /// Obtiene la cantidad total de un producto específico en el carrito
  Future<Either<Failure, int>> getProductQuantity(Product product);

  /// Reduce el stock de los productos después del pago
  Future<Either<Failure, void>> reduceStockAfterPayment();
}
