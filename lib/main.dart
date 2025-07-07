import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers.dart';

import 'firebase_options.dart';

import 'features/auth/presentation/pages/login_view.dart';
import 'features/auth/presentation/pages/register_view.dart';

// Home
import 'features/home/presentation/pages/home_view.dart';

// Menu
//import 'features/menu/presentation/pages/menu_list_page.dart';
import 'features/menu/presentation/pages/menu_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(providers: appProviders(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
        '/menu': (context) => const MenuView(),
      },
    );
  }
}
