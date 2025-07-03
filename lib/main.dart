import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'features/auth/data/repositories/firebase_auth_repository.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/domain/usecases/sign_in_with_email_password.dart';
import 'features/auth/domain/usecases/register_with_email_password.dart';
import 'features/auth/domain/usecases/get_id_token.dart';

import 'features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'features/auth/presentation/viewmodels/register_viewmodel.dart';

import 'features/auth/presentation/pages/login_view.dart';
import 'features/auth/presentation/pages/register_view.dart';
import 'features/home/presentation/pages/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = FirebaseAuthRepository();

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
        // '/welcome': (context) => const WelcomeView(), // si tenés una
      },
    );
  }
}
