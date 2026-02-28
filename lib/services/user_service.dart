import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>?> getUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map(
          (doc) => doc.data(),
        );
  }

  Stream<String> getUserRole(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.data()?['role'] ?? 'auditor');
  }

  Future<void> updateRole(String uid, String role) async {
    await _db.collection('users').doc(uid).update({
      "role": role,
    });
  }
}