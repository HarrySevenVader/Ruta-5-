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
              return ListTile(
                title: Text(menu.dish.name),
                subtitle: Text(menu.dish.description),
              );
            },
          );
        },
      ),
    );
  }
}
