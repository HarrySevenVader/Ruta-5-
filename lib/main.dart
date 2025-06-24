import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';

import 'presentation/screens/welcome_view.dart';
import 'presentation/screens/login_view.dart';
import 'presentation/screens/register_view.dart';
import 'presentation/screens/success_view.dart';
import 'presentation/screens/order_mode_view.dart';
//import 'views/home_view.dart';
//import 'views/menu_screen.dart';

// Funcion principal
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Se asegura que los widgets estén correctamente enlazados antes de ejecutar codigo
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Se inicializa Firebase con las opciones correctas para la plataforma

  runApp(const MyApp()); // Se inicia la app con el widget raíz MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodtem', // Nombre de la app
      debugShowCheckedModeBanner:
          false, // Se oculta el banner de "debug" de la esquina superior
      theme: ThemeData(
        primarySwatch:
            Colors.indigo, // Color principal (para AppBar, botones, etc.)
        scaffoldBackgroundColor: Colors.white, // Fondo blanco por defecto
        // Estilo global para los botones elevados (ElevatedButton)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        // Estilo para los campos de texto (TextFormField)
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      initialRoute: '/', // Ruta que se carga primero al iniciar la app
      // Mapa de rutas que definen a qué widget corresponde cada ruta
      routes: {
        '/': (context) => WelcomeView(), // Pantalla de bienvenida
        '/login': (context) => const LoginView(), // Pantalla de login
        '/register': (context) => const RegisterView(), // Pantalla de registro
        '/success': (context) => const SuccessView(), // Pantalla de éxito
        '/order':
            (context) => const OrderModeView(), // Pantalla modalidad pedido
        //'/home': (context) => const HomeView(), // Pantalla principal
      },
    );
  }
}
