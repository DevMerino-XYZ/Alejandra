import 'package:firebase_auth/firebase_auth.dart';

class LogoutService {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}