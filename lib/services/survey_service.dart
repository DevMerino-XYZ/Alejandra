import '../utils/firestore_refs.dart';
import '../models/survey_model.dart';
import '../models/question_model.dart';

class SurveyService {

  Future<List<SurveyModel>> getActiveSurveys() async {
    final snapshot = await FirestoreRefs.surveys
        .where('status', isEqualTo: 'active')
        .get();

    return snapshot.docs
        .map((doc) => SurveyModel.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ))
        .toList();
  }

  Future<List<QuestionModel>> getQuestions(String surveyId) async {
    final snapshot = await FirestoreRefs.surveys
        .doc(surveyId)
        .collection('questions')
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => QuestionModel.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ))
        .toList();
  }
}