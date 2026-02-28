import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firestore_refs.dart';
import '../models/response_model.dart';

class InspectionService {

  Future<String> createInspection(Map<String, dynamic> data) async {
    final doc = await FirestoreRefs.inspections.add(data);
    return doc.id;
  }

  Future<void> saveResponse({
    required String inspectionId,
    required ResponseModel response,
  }) async {
    await FirestoreRefs.inspections
        .doc(inspectionId)
        .collection('responses')
        .doc(response.questionId)
        .set(response.toMap());
  }

  Future<void> completeInspection({
    required String inspectionId,
    required double scoreTotal,
    required double maxScore,
  }) async {
    final percentage = (scoreTotal / maxScore) * 100;

    await FirestoreRefs.inspections.doc(inspectionId).update({
      'status': 'completed',
      'scoreTotal': scoreTotal,
      'maxScore': maxScore,
      'percentage': percentage,
      'completedAt': FieldValue.serverTimestamp(),
    });
  }
}