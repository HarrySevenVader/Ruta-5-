import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/menu_viewmodel.dart';
import '../../domain/entities/menu_entity.dart';

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
                      ...menu.drinks
                          .map(
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
                              subtitle: Text('${drink.volume} ${drink.unit}'),
                              trailing: Text('\$${drink.price}'),
                            ),
                          )
                          .toList(),
                    // Lista de platos (si los hay)
                    if (menu.dishes.isNotEmpty)
                      ...menu.dishes
                          .map(
                            (dish) => ListTile(
                              title: Text(dish.name),
                              subtitle: Text(dish.description),
                            ),
                          )
                          .toList(),
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
