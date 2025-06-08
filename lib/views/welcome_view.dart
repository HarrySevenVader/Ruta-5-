import 'package:flutter/material.dart';
import 'login_view.dart';
import 'register_view.dart';

// Pantalla de bienvenida de la app.
// Widget sin estado porque no requiere cambios dinámicos.
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos un Container con gradiente como fondo
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF181818), // Negro oscuro
                Color(0xFF353535), // Negro medio
                Color(0xFF4F4F4F), // Negro brillante (más claro)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            // Permite hacer scroll si el contenido no cabe en pantalla
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Solo ocupa el espacio necesario
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centra horizontalmente
                children: [
                  // Logotipo de la app
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 140),
                    child: Image.asset(
                      'assets/logo_app.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Título de la app/restaurante
                  const Text(
                    'FOODTEM',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descripción del servicio
                  const Text(
                    '🍔¡Descubre nuevos sabores!🍟 \n\nRegístrate para acceder a productos exclusivos. Disfruta de comida deliciosa y bebidas refrescantes a precios increíbles. ¡Haz tu pedido fácil y rápido! 🎉🍹',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Botón para iniciar sesión
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF00BFFF,
                        ), // Azul eléctrico
                        foregroundColor: Colors.white, // Texto blanco
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Iniciar Sesión",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botón para registro
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterView()),
                      );
                    },
                    child: const Text(
                      "¿No tienes cuenta? Regístrate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
