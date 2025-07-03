import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/menu_entity.dart';
import '../viewmodels/menu_viewmodel.dart';
import 'dish_detail_page.dart';

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
                  return ListTile(
                    leading: Image.network(menu.dish.img, width: 60),
                    title: Text(menu.dish.name),
                    subtitle: Text(menu.category.name),
                    trailing: Text('\$${menu.dish.price}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DishDetailPage(dish: menu.dish),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
