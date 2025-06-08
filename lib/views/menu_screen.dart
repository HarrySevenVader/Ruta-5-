import 'package:flutter/material.dart';
import 'product_detail_view.dart';
import 'cart_view.dart';
import '../models/product.dart'; // <-- Importa el modelo Product
import '../models/cart_model.dart'; // <-- Para el acceso al carrito si lo necesitas

// Lista de productos (simulada)
final List<Product> products = [
  Product(
    name: 'Empanada',
    category: 'Entradas',
    ingredients: ['carne', 'cebolla'],
    price: 5.0,
    imagePath: 'assets/empanada.png',
  ),
  Product(
    name: 'Papas Fritas',
    category: 'Entradas',
    ingredients: ['papas', 'aceite', 'sal'],
    price: 4.5,
    imagePath: 'assets/papas-fritas.png',
    isAvailable: false,
  ),
  Product(
    name: 'Lomo Saltado',
    category: 'Platos Fuertes',
    ingredients: ['carne', 'papas', 'arroz'],
    price: 12.0,
    imagePath: 'assets/lomo-saltado.png',
  ),
  Product(
    name: 'Hamburguesa',
    category: 'Platos Fuertes',
    ingredients: ['carne', 'pan', 'queso', 'lechuga'],
    price: 9.5,
    imagePath: 'assets/hamburguesa.png',
  ),
  Product(
    name: 'Inca Kola',
    category: 'Bebidas',
    ingredients: ['gaseosa'],
    price: 2.0,
    imagePath: 'assets/inca_kola.png',
  ),
  Product(
    name: 'Jugo Natural',
    category: 'Bebidas',
    ingredients: ['naranja', 'agua'],
    price: 3.0,
    imagePath: 'assets/jugo.png',
  ),
  Product(
    name: 'Donas',
    category: 'Postres',
    ingredients: ['harina', 'azúcar', 'glaseado'],
    price: 3.5,
    imagePath: 'assets/donas.png',
  ),
  Product(
    name: 'Queque de Vainilla',
    category: 'Postres',
    ingredients: ['harina', 'vainilla', 'huevo'],
    price: 4.0,
    imagePath: 'assets/queque.png',
    isAvailable: false,
  ),
];

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = [
    'Entradas',
    'Platos Fuertes',
    'Bebidas',
    'Postres',
  ];
  double? minPrice;
  double? maxPrice;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF14532D),
                Color(0xFF22C55E),
                Color.fromARGB(255, 43, 173, 38),
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Menú del Restaurante',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(products),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.filter_alt, color: Colors.white),
                onPressed: () async {
                  final result =
                      await showModalBottomSheet<Map<String, double>>(
                        context: context,
                        builder: (_) => const PriceFilterSheet(),
                      );
                  if (result != null) {
                    setState(() {
                      minPrice = result['min'];
                      maxPrice = result['max'];
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  ).then((_) => setState(() {}));
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: categories.map((cat) => Tab(text: cat)).toList(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
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
          child: TabBarView(
            controller: _tabController,
            children:
                categories.map((category) {
                  final filtered =
                      products.where((p) {
                        final matchesCategory = p.category == category;
                        final matchesMin =
                            minPrice == null || p.price >= minPrice!;
                        final matchesMax =
                            maxPrice == null || p.price <= maxPrice!;
                        return matchesCategory && matchesMin && matchesMax;
                      }).toList();

                  return ProductList(products: filtered);
                }).toList(),
          ),
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<Product> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No hay productos en esta categoría.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return Card(
          color: p.isAvailable ? const Color(0xFF14532D) : Colors.grey[700],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap:
                p.isAvailable
                    ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailView(product: p),
                        ),
                      );
                    }
                    : null,
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                ListTile(
                  leading: Hero(
                    tag: 'product-${p.name}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          p.isAvailable ? Colors.transparent : Colors.grey,
                          BlendMode.saturation,
                        ),
                        child: Image.asset(
                          p.imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    p.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration:
                          p.isAvailable ? null : TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Text(
                    '${p.ingredients.join(', ')}\nS/ ${p.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  isThreeLine: true,
                  trailing:
                      p.isAvailable
                          ? const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white54,
                            size: 20,
                          )
                          : null,
                ),
                if (!p.isAvailable)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'AGOTADO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<Product> {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed:
        () => close(
          context,
          Product(
            name: '',
            category: '',
            ingredients: [],
            price: 0,
            imagePath: '',
          ),
        ),
  );

  @override
  Widget buildResults(BuildContext context) {
    final results =
        products.where((p) {
          return p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.ingredients.any(
                (i) => i.toLowerCase().contains(query.toLowerCase()),
              ) ||
              (double.tryParse(query) != null &&
                  p.price <= double.parse(query));
        }).toList();

    return ProductList(products: results);
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}

class PriceFilterSheet extends StatefulWidget {
  const PriceFilterSheet({super.key});

  @override
  State<PriceFilterSheet> createState() => _PriceFilterSheetState();
}

class _PriceFilterSheetState extends State<PriceFilterSheet> {
  double _min = 0;
  double _max = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filtrar por precio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            RangeSlider(
              values: RangeValues(_min, _max),
              min: 0,
              max: 50,
              divisions: 50,
              labels: RangeLabels(
                'S/ ${_min.toStringAsFixed(1)}',
                'S/ ${_max.toStringAsFixed(1)}',
              ),
              onChanged:
                  (values) => setState(() {
                    _min = values.start;
                    _max = values.end;
                  }),
              activeColor: const Color(0xFF22C55E),
              inactiveColor: Colors.white24,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed:
                  () => Navigator.pop(context, {'min': _min, 'max': _max}),
              icon: const Icon(Icons.check),
              label: const Text('Aplicar'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: const Color.fromARGB(255, 60, 190, 27),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
