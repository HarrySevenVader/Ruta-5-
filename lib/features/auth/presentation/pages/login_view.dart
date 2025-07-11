import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final screenSize = MediaQuery.of(context).size;
    final isSmallDevice = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo gris con gradiente de gris oscuro intenso a blanco, sin border radius
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenSize.height * 0.55,
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

          // Imagen del plato de comida posicionada a la izquierda encima del gradiente
          Positioned(
            top: screenSize.height * 0.100,
            left: -screenSize.width * 0.15,
            width: screenSize.width * 0.8,
            height: screenSize.width * 0.8,
            child: Hero(
              tag: 'food_image',
              child: Image.asset(
                'assets/images/platocomida.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Botón circular superpuesto sobre la imagen en la esquina derecha
          Positioned(
            top: screenSize.height * 0.45,
            right: screenSize.width * 0.1,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.green.shade200.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.navigation, color: Colors.white, size: 30),
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // Espacio para que el contenido principal no choque con la imagen
                SizedBox(height: screenSize.height * 0.48),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallDevice ? 28.0 : 48.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título principal en dos líneas con estilo moderno
                        Text(
                          'Ruta 5',
                          style: TextStyle(
                            fontSize: isSmallDevice ? 36 : 42,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            height: 0.9,
                          ),
                        ),
                        Text(
                          'Tu camino',
                          style: TextStyle(
                            fontSize: isSmallDevice ? 36 : 42,
                            fontWeight: FontWeight.w300,
                            color: Colors.black45,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: isSmallDevice ? 16 : 24),

                        // Texto descriptivo
                        Text(
                          'Una aplicación que te conecta con los mejores servicios a lo largo del camino',
                          style: TextStyle(
                            fontSize: isSmallDevice ? 14 : 16,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),

                        const Spacer(),

                        // Mensaje de error
                        if (viewModel.errorMessage != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              viewModel.errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),

                        // Botón de inicio de sesión con Google
                        if (viewModel.isLoading)
                          Center(child: const CircularProgressIndicator())
                        else
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              bottom: isSmallDevice ? 20 : 30,
                            ),
                            child: ElevatedButton.icon(
                              icon: Image.asset(
                                'assets/images/logo_google.png',
                                height: 20,
                              ),
                              label: Text(
                                'Continuar con Google',
                                style: TextStyle(
                                  fontSize: isSmallDevice ? 15 : 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () async {
                                await viewModel.loginWithGoogle();
                                if (viewModel.user != null && mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallDevice ? 16 : 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),

                        // Nota sobre el dominio permitido
                        Center(
                          child: Text(
                            'Solo se permiten cuentas con dominio @utem.cl',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallDevice ? 11 : 12,
                              color: Colors.black45,
                            ),
                          ),
                        ),

                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
