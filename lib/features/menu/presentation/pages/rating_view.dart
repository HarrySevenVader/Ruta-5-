import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/rateable_item.dart';
import '../viewmodels/rating_viewmodel.dart';

class RatingView extends StatefulWidget {
  final RateableItem item;

  const RatingView({super.key, required this.item});

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  final TextEditingController _commentController = TextEditingController();

  void _resetForm() {
    _commentController.clear();
    final viewModel = Provider.of<RatingViewModel>(context, listen: false);
    viewModel.reset();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<RatingViewModel>(context, listen: false);
      // Limpiar completamente el formulario
      _resetForm();
      // Establecer el nuevo producto (esto resetea todo el estado)
      viewModel.setItem(widget.item);

      // Sincronizar el controller con los cambios del ViewModel
      _commentController.addListener(() {
        if (!viewModel.isSubmitted) {
          // Solo actualizar si no se ha enviado
          viewModel.setComment(_commentController.text);
        }
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final accentGreen = Colors.green.shade200;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo gris con gradiente de gris oscuro intenso a blanco, sin border radius
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenSize.height * 0.22,
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
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Valorar Producto',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48), // Para mantener el título centrado
                  ],
                ),
              ),
            ),
          ),

          // Contenido principal con Consumer
          Positioned(
            top: screenSize.height * 0.12, // Debajo del gradiente
            left: 0,
            right: 0,
            bottom: 0,
            child: Consumer<RatingViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.isSubmitted) {
                  return _buildSuccessView(context, accentGreen);
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Imagen y nombre del plato con nuevo estilo
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            // Imagen del plato
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child:
                                    widget.item.img.isNotEmpty
                                        ? Image.network(
                                          widget.item.img,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Icon(
                                                Icons.restaurant,
                                                size: 80,
                                                color: accentGreen,
                                              ),
                                            );
                                          },
                                        )
                                        : Container(
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.restaurant,
                                            size: 80,
                                            color: accentGreen,
                                          ),
                                        ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Nombre del plato
                            Text(
                              widget.item.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // Descripción o info adicional
                            Text(
                              widget.item.displayInfo,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // Precio
                            Text(
                              '\$${widget.item.price}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: accentGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Separador
                      Container(height: 8, color: Colors.grey[100]),

                      // Sección de valoración
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                '¿Qué te pareció este producto?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Estrellas para calificación
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    icon: Icon(
                                      index < viewModel.selectedRating
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 36,
                                    ),
                                    color: Colors.amber,
                                    onPressed: () {
                                      viewModel.setRating(index + 1);
                                    },
                                  );
                                }),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Campo de comentario
                            TextField(
                              controller: _commentController,
                              maxLength: 255,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: 'Comentarios (opcional)',
                                hintText:
                                    'Comparte tu opinión sobre este producto',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: accentGreen,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Botón enviar con el estilo consistente
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed:
                                    viewModel.selectedRating > 0
                                        ? () {
                                          viewModel.submitRating();
                                        }
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Enviar Valoración',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            
                            // Mensaje de error
                            if (viewModel.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Text(
                                    viewModel.errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red.shade800,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, Color accentGreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: accentGreen.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 80,
                color: accentGreen,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '¡Gracias por tu valoración!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Tu opinión es muy importante para nosotros y nos ayuda a mejorar nuestros productos.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Volver al Menú',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
