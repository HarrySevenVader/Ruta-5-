import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/menu_viewmodel.dart';
import 'rating_view.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  @override
  void initState() {
    super.initState();
    context.read<MenuViewModel>().fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MenuViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Menú del Día')),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.error != null
              ? Center(child: Text(viewModel.error!))
              : ListView.builder(
                itemCount: viewModel.menus.length,
                itemBuilder: (context, index) {
                  final menu = viewModel.menus[index];
                  return ExpansionTile(
                    title: Text(menu.category.name),
                    children: [
                      // Mostrar platos si los hay
                      if (menu.dishes.isNotEmpty)
                        ...menu.dishes.map(
                          (dish) => ListTile(
                            leading:
                                dish.img.isNotEmpty
                                    ? Image.network(dish.img, width: 60)
                                    : const Icon(Icons.restaurant),
                            title: Text(dish.name),
                            subtitle: Text(dish.description),
                            trailing: Text('\$${dish.price}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RatingView(item: dish),
                                ),
                              );
                            },
                          ),
                        ),
                      // Mostrar bebidas si las hay
                      if (menu.drinks.isNotEmpty)
                        ...menu.drinks.map(
                          (drink) => ListTile(
                            leading:
                                drink.img.isNotEmpty
                                    ? Image.network(drink.img, width: 60)
                                    : const Icon(Icons.local_drink),
                            title: Text(drink.name),
                            subtitle: Text('${drink.volume} ${drink.unit}'),
                            trailing: Text('\$${drink.price}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RatingView(item: drink),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
    );
  }
}
