import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/menu_viewmodel.dart';
import 'rating_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  void initState() {
    super.initState();
    // Ejecutar después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<MenuViewModel>(context, listen: false);
      viewModel.fetchMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú del Día')),
      body: Consumer<MenuViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          }

          if (viewModel.menus.isEmpty) {
            return const Center(child: Text('No hay menús disponibles.'));
          }

          return ListView.builder(
            itemCount: viewModel.menus.length,
            itemBuilder: (context, index) {
              final menu = viewModel.menus[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la categoría
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        menu.category.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    // Lista de bebidas
                    if (menu.drinks.isNotEmpty)
                      ...menu.drinks.map(
                        (drink) => ListTile(
                          leading:
                              drink.img.isNotEmpty
                                  ? Image.network(
                                    drink.img,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                  : Icon(Icons.local_drink),
                          title: Text(drink.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${drink.volume} ${drink.unit}'),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '\$${drink.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex < drink.rate.floor()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 16,
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${drink.rate.toStringAsFixed(1)})',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RatingView(item: drink),
                              ),
                            );
                          },
                        ),
                      ),
                    // Lista de platos (si los hay)
                    if (menu.dishes.isNotEmpty)
                      ...menu.dishes.map(
                        (dish) => ListTile(
                          leading:
                              dish.img.isNotEmpty
                                  ? Image.network(
                                    dish.img,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.restaurant);
                                    },
                                  )
                                  : const Icon(Icons.restaurant),
                          title: Text(dish.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dish.description),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '\$${dish.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex < dish.rate.floor()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 16,
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${dish.rate.toStringAsFixed(1)})',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RatingView(item: dish),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
