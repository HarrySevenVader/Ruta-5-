import 'package:flutter/material.dart';
import '../../domain/entities/dish_entity.dart';

class DishDetailPage extends StatelessWidget {
  final DishEntity dish;

  const DishDetailPage({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(dish.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(dish.img, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(dish.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(dish.description),
            const SizedBox(height: 16),
            Text('Precio: \$${dish.price}'),
            const SizedBox(height: 8),
            Text('Calificación: ${dish.rate}/5.0'),
            const SizedBox(height: 24),
            const Text('¿Te gustó este plato? (Funcionalidad futura)'),
            // Aquí podrías poner un botón o estrellas para valorar
          ],
        ),
      ),
    );
  }
}
