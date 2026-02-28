import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/firestore_refs.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// LOGIN PROFESIONAL
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1️⃣ Sign in
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // 2️⃣ Obtener el documento Firestore
      final userDoc = await FirestoreRefs.users.doc(uid).get();

      if (!userDoc.exists) {
        await _auth.signOut();
        throw Exception("User profile not found.");
      }

      // 3️⃣ Mapear datos con cast seguro para Web y Mobile
      final data = userDoc.data();
      if (data == null) {
        await _auth.signOut();
        throw Exception("User data is empty.");
      }

      final user = UserModel.fromMap((data as Map).cast<String, dynamic>());

      // 4️⃣ Validar que esté activo
      if (!user.isActive) {
        await _auth.signOut();
        throw Exception("User is disabled.");
      }

      // 5️⃣ Actualizar último login
      await FirestoreRefs.users.doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Authentication error");
    }
  }

  /// REGISTRO PROFESIONAL
  Future<UserModel> register({
    required String fullName,
    required String employeeId,
    required String email,
    required String password,
    required String company,
  }) async {
    try {
      // 1️⃣ Crear usuario en Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // 2️⃣ Crear modelo de usuario
      final user = UserModel(
        uid: uid,
        employeeId: employeeId,
        fullName: fullName,
        email: email,
        role: "auditor", // Rol fijo
        company: company,
        isActive: true,
        createdAt: DateTime.now(),
        lastLogin: null,
      );

      // 3️⃣ Guardar en Firestore
      await FirestoreRefs.users.doc(uid).set(user.toMap());

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Registration error");
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}