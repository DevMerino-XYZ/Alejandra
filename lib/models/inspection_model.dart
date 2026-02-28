import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionModel {
  final String id;
  final String surveyId;
  final String surveyTitle;
  final String userId;
  final String userEmail;
  final String status;
  final double scoreTotal;
  final double maxScore;
  final double percentage;
  final Timestamp startedAt;
  final Timestamp? completedAt;

  InspectionModel({
    required this.id,
    required this.surveyId,
    required this.surveyTitle,
    required this.userId,
    required this.userEmail,
    required this.status,
    required this.scoreTotal,
    required this.maxScore,
    required this.percentage,
    required this.startedAt,
    this.completedAt,
  });

  factory InspectionModel.fromMap(String id, Map<String, dynamic> map) {
    return InspectionModel(
      id: id,
      surveyId: map['surveyId'],
      surveyTitle: map['surveyTitle'],
      userId: map['userId'],
      userEmail: map['userEmail'],
      status: map['status'],
      scoreTotal: (map['scoreTotal'] ?? 0).toDouble(),
      maxScore: (map['maxScore'] ?? 0).toDouble(),
      percentage: (map['percentage'] ?? 0).toDouble(),
      startedAt: map['startedAt'],
      completedAt: map['completedAt'],
    );
  }
}