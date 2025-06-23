import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import '../../core/errors/failures.dart';

abstract class ProductRepository {
  /// Obtiene todos los productos
  Future<Either<Failure, List<Product>>> getProducts();

  /// Obtiene un producto por su ID
  Future<Either<Failure, Product>> getProductById(String id);

  /// Obtiene productos por categoría
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);

  /// Busca productos por nombre o descripción
  Future<Either<Failure, List<Product>>> searchProducts(String query);

  /// Verifica si hay stock disponible para un producto
  Future<Either<Failure, bool>> checkAvailability(
    String productId,
    int quantity,
  );

  /// Actualiza el stock de un producto
  Future<Either<Failure, void>> updateStock(String productId, int newStock);
}
