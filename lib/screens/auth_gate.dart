import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/user_home_screen.dart';
import '../screens/admin_home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/complete_profile_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // 1. Si no hay sesión iniciada
        if (!authSnapshot.hasData) {
          return const LoginScreen();
        }

        // 2. Si hay sesión, escuchamos el documento del usuario en tiempo real
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(authSnapshot.data!.uid)
              .snapshots(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            // Si el documento no existe o está vacío
            if (!profileSnapshot.hasData || !profileSnapshot.data!.exists) {
              return const CompleteProfileScreen();
            }

            final data = profileSnapshot.data!.data() as Map<String, dynamic>;
            final bool isCompleted = data['profileCompleted'] ?? false;
            final String role = data['role'] ?? 'user';

            if (!isCompleted) {
              return const CompleteProfileScreen();
            }

            // Redirección por rol
            return role == 'admin' ? const AdminHomeScreen() : const UserHomeScreen();
          },
        );
      },
    );
  }
}