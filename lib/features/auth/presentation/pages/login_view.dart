import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_viewmodel.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator:
                    (value) => value!.isEmpty ? 'Ingrese su correo' : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                  ),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Ingrese su contraseña' : null,
              ),
              const SizedBox(height: 20),
              if (viewModel.isLoading)
                const CircularProgressIndicator()
              else ...[
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await viewModel.loginWithEmailPassword(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                      if (viewModel.user != null && mounted) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    }
                  },
                  child: const Text('Iniciar sesión'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Continuar con Google'),
                  onPressed: () async {
                    await viewModel.loginWithGoogle();
                    if (viewModel.user != null && mounted) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                ),
                TextButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterView()),
                      ),
                  child: const Text('¿No tienes cuenta? Registrate'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
