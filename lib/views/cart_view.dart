import 'package:app_client/views/order_mode_view.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get totalCartPrice => CartModel().getTotalPrice();

  void _showCartItemDetails(BuildContext context, CartItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.product.imagePath,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.product.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cantidad: ${item.quantity}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Stock disponible: ${item.product.stock}',
                style: const TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
              Text(
                'Tamaño: ${item.size ?? 'Normal'}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Toppings: ${item.toppings.isNotEmpty ? item.toppings.join(', ') : 'Ninguno'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Ingredientes: ${item.product.ingredients.join(', ')}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Text(
                'Total: CLP ${item.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeCartItem(int index) {
    setState(() {
      CartModel().removeItemAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartModel().items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Carrito'),
        backgroundColor: const Color(0xFF14532D),
        foregroundColor: Colors.white,
      ),
      body:
          cartItems.isEmpty
              ? const Center(
                child: Text(
                  'Tu carrito está vacío.',
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Dismissible(
                    key: Key(item.hashCode.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _removeCartItem(index),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () => _showCartItemDetails(context, item),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.product.imagePath,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          '${item.product.name} x${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Tamaño: ${item.size ?? 'Normal'}\n'
                          'Toppings: ${item.toppings.isNotEmpty ? item.toppings.join(', ') : 'Ninguno'}\n'
                          'Stock: ${item.product.stock}',
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CLP ${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Flexible(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeCartItem(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar:
          cartItems.isNotEmpty
              ? Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'CLP ${totalCartPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF14532D),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Mostrar OrderModeView como modal
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (_) => const OrderModeView(),
                          );
                        },
                        child: const Text(
                          'Realizar Pedido',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}
