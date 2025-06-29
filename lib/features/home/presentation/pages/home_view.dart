import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/data/repositories/firebase_auth_repository.dart';
import '../../../auth/domain/entities/user_entity.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = FirebaseAuthRepository();

    return StreamBuilder<UserEntity?>(
      stream: authRepo.userChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (user == null) {
          // Usuario no logueado, redirigir
          Future.microtask(() => Navigator.pushReplacementNamed(context, '/'));
          return const SizedBox.shrink();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Inicio'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await authRepo.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
              )
            ],
          ),
          body: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF14532D),
                    Color(0xFF22C55E),
                    Color.fromARGB(255, 38, 219, 104),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hola, ${user.displayName ?? user.email}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 16),
                  Text('UID: ${user.uid}',
                      style: const TextStyle(color: Colors.white70)),
                  // Agregá más widgets personalizados aquí
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
