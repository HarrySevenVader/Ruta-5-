import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../auth/data/repositories/firebase_auth_repository.dart';
import '../../../auth/domain/entities/user_entity.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _jwt;
  bool _isLoading = false;

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
              ),
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
                  Text(
                    'Hola, ${user.displayName ?? user.email}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'UID: ${user.uid}',
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.key),
                    label: const Text('Ver JWT'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green[900],
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        // Asegúrate de que este método exista en tu repositorio
                        final token = await authRepo.getIdToken();
                        setState(() {
                          _jwt = token;
                          _isLoading = false;
                        });
                      } catch (e) {
                        setState(() {
                          _jwt = "Error al obtener el token: $e";
                          _isLoading = false;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),

                  if (_jwt != null && !_isLoading) ...[
                    const Text(
                      'JWT Token:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _jwt!.length > 40
                                ? '${_jwt!.substring(0, 40)}...'
                                : _jwt!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.copy,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _jwt!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Token copiado al portapapeles',
                                      ),
                                    ),
                                  );
                                },
                                tooltip: 'Copiar token',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
