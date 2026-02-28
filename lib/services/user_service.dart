import '../utils/firestore_refs.dart';
import '../models/user_model.dart';

class UserService {

  Future<void> createUser(UserModel user) async {
    await FirestoreRefs.users.doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await FirestoreRefs.users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}