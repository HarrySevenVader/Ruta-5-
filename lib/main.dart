import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// Auth
import 'features/auth/data/repositories/firebase_auth_repository.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/domain/usecases/sign_in_with_email_password.dart';
import 'features/auth/domain/usecases/register_with_email_password.dart';
import 'features/auth/domain/usecases/get_id_token.dart';

import 'features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'features/auth/presentation/viewmodels/register_viewmodel.dart';
import 'features/auth/presentation/pages/login_view.dart';
import 'features/auth/presentation/pages/register_view.dart';

// Home
import 'features/home/presentation/pages/home_view.dart';

// Menu
import 'features/menu/data/datasources/menu_api_datasource.dart';
import 'features/menu/data/repositories/menu_repository_impl.dart';
import 'features/menu/domain/usecases/get_today_menu.dart';
import 'features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'features/menu/presentation/pages/menu_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = FirebaseAuthRepository();
  final menuRepository = MenuRepositoryImpl(MenuApiDatasource());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => LoginViewModel(
                signInWithGoogle: SignInWithGoogle(authRepository),
                signInWithEmailPassword: SignInWithEmailPassword(
                  authRepository,
                ),
                getIdToken: GetIdToken(authRepository),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) =>
                  RegisterViewModel(RegisterWithEmailPassword(authRepository)),
        ),
        ChangeNotifierProvider(
          create: (_) => MenuViewModel(GetTodayMenu(menuRepository)),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
        '/menu': (context) => const MenuListPage(),
      },
    );
  }
}
