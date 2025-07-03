import 'package:flutter/material.dart';

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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/');
          });
          return const SizedBox.shrink();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/menu');
        });

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
