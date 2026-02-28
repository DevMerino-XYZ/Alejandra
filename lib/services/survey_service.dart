import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Obtener encuestas activas
  Stream<QuerySnapshot> getActiveSurveys() {
    return _db
        .collection('surveys')
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // 🔹 Crear encuesta
  Future<void> createSurvey(Map<String, dynamic> data) async {
    await _db.collection('surveys').add({
      ...data,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // 🔹 Eliminar encuesta
  Future<void> deleteSurvey(String surveyId) async {
    await _db.collection('surveys').doc(surveyId).delete();
  }

  // 🔹 Agregar pregunta
  Future<void> addQuestion(
      String surveyId, Map<String, dynamic> data) async {
    await _db
        .collection('surveys')
        .doc(surveyId)
        .collection('questions')
        .add(data);
  }

  // 🔹 Obtener preguntas
  Stream<QuerySnapshot> getQuestions(String surveyId) {
    return _db
        .collection('surveys')
        .doc(surveyId)
        .collection('questions')
        .orderBy('order')
        .snapshots();
  }
}