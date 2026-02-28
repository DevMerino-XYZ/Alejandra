import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Crear inspección
  Future<DocumentReference> createInspection(
      Map<String, dynamic> data) async {
    return await _db.collection('inspections').add({
      ...data,
      "startedAt": FieldValue.serverTimestamp(),
    });
  }

  // 🔹 Guardar respuesta
  Future<void> saveResponse(String inspectionId,
      Map<String, dynamic> data) async {
    await _db
        .collection('inspections')
        .doc(inspectionId)
        .collection('responses')
        .add(data);
  }

  // 🔹 Finalizar inspección
  Future<void> completeInspection(
      String inspectionId, Map<String, dynamic> data) async {
    await _db.collection('inspections').doc(inspectionId).update({
      ...data,
      "completedAt": FieldValue.serverTimestamp(),
      "status": "completed",
    });
  }

  // 🔹 Admin: ver todas
  Stream<QuerySnapshot> getAllInspections() {
    return _db
        .collection('inspections')
        .orderBy('completedAt', descending: true)
        .snapshots();
  }

  // 🔹 Usuario: ver propias
  Stream<QuerySnapshot> getUserInspections(String uid) {
    return _db
        .collection('inspections')
        .where('userId', isEqualTo: uid)
        .orderBy('completedAt', descending: true)
        .snapshots();
  }
}