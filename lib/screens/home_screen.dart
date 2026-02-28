import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // No debería ocurrir si AuthGate funciona correctamente
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return FutureBuilder<UserModel?>(
      future: UserService().getUser(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        final userModel = snapshot.data;
        if (userModel == null) {
          return const Scaffold(
            body: Center(child: Text("User not found")),
          );
        }

        return WelcomeScreen(
          key: ValueKey(userModel.uid),
          fullName: userModel.fullName,
          role: userModel.role,
        );
      },
    );
  }
}