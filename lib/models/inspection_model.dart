import 'package:cloud_firestore/cloud_firestore.dart';

class Inspection {
  final String id;
  final String surveyId;
  final String surveyTitle;
  final String userName;
  final String userId;
  final DateTime date;
  final List<Map<String, dynamic>> answers;

  Inspection({required this.id, required this.surveyId, required this.surveyTitle, required this.userName, required this.userId, required this.date, required this.answers});

  Map<String, dynamic> toMap() => {
    'surveyId': surveyId, 'surveyTitle': surveyTitle, 'userName': userName, 'userId': userId, 'date': Timestamp.fromDate(date), 'answers': answers,
  };

  factory Inspection.fromFirestore(Map<String, dynamic> data, String id) => Inspection(
    id: id,
    surveyId: data['surveyId'] ?? '',
    surveyTitle: data['surveyTitle'] ?? '',
    userName: data['userName'] ?? '',
    userId: data['userId'] ?? '',
    date: (data['date'] as Timestamp).toDate(),
    answers: List<Map<String, dynamic>>.from(data['answers'] ?? []),
  );
}