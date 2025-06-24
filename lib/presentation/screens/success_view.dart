import 'package:flutter/material.dart';
import 'home_view.dart';

class SuccessView extends StatefulWidget {
  const SuccessView({super.key});

  @override
  State<SuccessView> createState() => _SuccessViewState();
}

// Estado asociado a la vista de éxito
class _SuccessViewState extends State<SuccessView> {
  @override
  void initState() {
    super.initState();
    // Se espera 2 segundos y luego se navega a HomeView
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Verifica que el widget aún esté en el árbol antes de navegar
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ), // Redirige reemplazando la vista actual
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ), // Ícono de éxito
            SizedBox(height: 20),
            Text(
              '¡Ingreso exitoso!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Redirigiendo...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ), // Mensaje de espera
            ),
          ],
        ),
      ),
    );
  }
}
