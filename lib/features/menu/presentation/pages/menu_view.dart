import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final Color accentGreen = Colors.green.shade200;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo gris con gradiente de gris oscuro intenso a blanco, sin border radius
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height:
                screenSize.height *
                0.25, // Más pequeño que en la página de login
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.grey.shade900, // Gris muy oscuro, casi negro
                    Colors.grey.shade700, // Gris oscuro
                    Colors.grey.shade400, // Gris medio
                    Colors.grey.shade100, // Gris muy claro
                    Colors.white, // Blanco puro
                  ],
                  stops: [0.0, 0.25, 0.5, 0.8, 1.0],
                ),
              ),
            ),
          ),

          // AppBar transparente con título
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    // Espacio para mantener el título centrado
                    SizedBox(width: 48),
                    Expanded(
                      child: Text(
                        'Menú del Día',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.black),
                      tooltip: 'Cerrar sesión',
                      onPressed: () => _handleLogout(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Contenido principal
          Padding(
            padding: EdgeInsets.only(top: screenSize.height * 0.13),
            child: Consumer<MenuViewModel>(
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
                  padding: EdgeInsets.only(top: 20),
                  itemCount: viewModel.menus.length,
                  itemBuilder: (context, index) {
                    final menu = viewModel.menus[index];
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título de la categoría con estilo consistente
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade100,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              menu.category.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),

                          // Lista de bebidas con nuevo estilo
                          if (menu.drinks.isNotEmpty)
                            ...menu.drinks.map(
                              (drink) => ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child:
                                      drink.img.isNotEmpty
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              drink.img,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                          : Icon(
                                            Icons.local_drink,
                                            color: accentGreen,
                                            size: 30,
                                          ),
                                ),
                                title: Text(
                                  drink.name,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${drink.volume} ${drink.unit}'),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '\$${drink.price}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: accentGreen,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Row(
                                          children: List.generate(5, (
                                            starIndex,
                                          ) {
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
                                trailing: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: accentGreen.withOpacity(0.9),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => RatingView(item: drink),
                                    ),
                                  );
                                },
                              ),
                            ),

                          // Lista de platos con nuevo estilo
                          if (menu.dishes.isNotEmpty)
                            ...menu.dishes.map(
                              (dish) => ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child:
                                      dish.img.isNotEmpty
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              dish.img,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Icon(
                                                  Icons.restaurant,
                                                  color: Colors.grey.shade400,
                                                  size: 30,
                                                );
                                              },
                                            ),
                                          )
                                          : Icon(
                                            Icons.restaurant,
                                            color: accentGreen,
                                            size: 30,
                                          ),
                                ),
                                title: Text(
                                  dish.name,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dish.description),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '\$${dish.price}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: accentGreen,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Row(
                                          children: List.generate(5, (
                                            starIndex,
                                          ) {
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
                                trailing: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: accentGreen.withOpacity(0.9),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => RatingView(item: dish),
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
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Mostrar diálogo de confirmación
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar sesión'),
        content: Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        // Obtener SharedPreferences para limpiar el JWT
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('jwt'); // Eliminar el token JWT
        
        // Navegar de vuelta a la pantalla de login (que está definida como ruta '/')
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      } catch (e) {
        print('Error al cerrar sesión: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión. Intenta de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
