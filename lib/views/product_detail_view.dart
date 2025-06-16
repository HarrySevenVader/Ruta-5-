import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/cart_model.dart';

class ProductDetailView extends StatefulWidget {
  final Product product;

  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int quantity = 1;
  String? selectedSize;
  final Map<String, bool> selectedToppings = {};
  final Map<String, double> toppingPrices = {
    'Queso extra': 1500,
    'Tocino': 2000,
    'Champiñones': 1000,
    'Palta': 1500,
    'Huevo frito': 2000,
  };

  double get totalPrice {
    double basePrice = widget.product.price * quantity;
    double toppingsPrice = 0.0;

    // Agregar precio de toppings seleccionados
    selectedToppings.forEach((topping, isSelected) {
      if (isSelected) {
        toppingsPrice += toppingPrices[topping] ?? 0;
      }
    });

    // Ajustar precio por tamaño
    double sizeMultiplier = 1.0;
    if (selectedSize == 'Mediano') {
      sizeMultiplier = 1.3;
    } else if (selectedSize == 'Grande') {
      sizeMultiplier = 1.6;
    }

    return (basePrice + toppingsPrice * quantity) * sizeMultiplier;
  }

  @override
  void initState() {
    super.initState();
    // Inicializar toppings como no seleccionados
    for (final topping in toppingPrices.keys) {
      selectedToppings[topping] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF14532D),
              Color(0xFF22C55E),
              Color.fromARGB(255, 38, 219, 104),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: Column(
                children: [
                  // Imagen y nombre del producto
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen del producto
                        Center(
                          child: Hero(
                            tag: 'product-${widget.product.name}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                widget.product.imagePath,
                                height: constraints.maxHeight * 0.2,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Nombre y precio
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'CLP ${widget.product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Ingredientes
                        Text(
                          'Ingredientes: ${widget.product.ingredients.join(', ')}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Panel de personalización
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            // Selector de cantidad
                            const Text(
                              'Cantidad',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF14532D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.remove_circle),
                                  color: const Color(0xFF14532D),
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  icon: const Icon(Icons.add_circle),
                                  color: const Color(0xFF14532D),
                                ),
                              ],
                            ),
                            const Divider(),

                            // Selector de tamaño (solo si aplica)
                            if (widget.product.category == 'Platos Fuertes' ||
                                widget.product.category == 'Bebidas') ...[
                              const Text(
                                'Tamaño',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF14532D),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                children:
                                    ['Pequeño', 'Mediano', 'Grande'].map((
                                      size,
                                    ) {
                                      return ChoiceChip(
                                        label: Text(size),
                                        selected: selectedSize == size,
                                        onSelected: (selected) {
                                          setState(() {
                                            selectedSize =
                                                selected ? size : null;
                                          });
                                        },
                                        backgroundColor: Colors.grey[200],
                                        selectedColor: const Color(0xFF22C55E),
                                        labelStyle: TextStyle(
                                          color:
                                              selectedSize == size
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      );
                                    }).toList(),
                              ),
                              const Divider(),
                            ],

                            // Selector de toppings extras (solo si aplica para este producto)
                            if (widget.product.category == 'Platos Fuertes' ||
                                widget.product.name.contains(
                                  'Hamburguesa',
                                )) ...[
                              const Text(
                                'Extras',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF14532D),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...toppingPrices.entries.map((entry) {
                                return CheckboxListTile(
                                  title: Text(entry.key),
                                  subtitle: Text(
                                    '+ CLP ${entry.value.toStringAsFixed(2)}',
                                  ),
                                  value: selectedToppings[entry.key] ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedToppings[entry.key] =
                                          value ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFF22C55E),
                                  checkColor: Colors.white,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                );
                              }).toList(),
                              const Divider(),
                            ],

                            // Notas especiales (solo UI, no se guarda)
                            const Text(
                              'Instrucciones especiales',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF14532D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Ej: Sin cebolla, salsa aparte...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),

                            // Botón de agregar al carrito
                            ElevatedButton.icon(
                              onPressed: () {
                                CartModel().add(
                                  CartItem(
                                    product: widget.product,
                                    quantity: quantity,
                                    size: selectedSize,
                                    toppings:
                                        selectedToppings.entries
                                            .where((e) => e.value)
                                            .map((e) => e.key)
                                            .toList(),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${widget.product.name} agregado al carrito',
                                    ),
                                    backgroundColor: const Color(0xFF22C55E),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.shopping_cart),
                              label: Text(
                                'Agregar al carrito - CLP ${totalPrice.toStringAsFixed(2)}',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF14532D),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
