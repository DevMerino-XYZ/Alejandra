import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  final String id;
  final String title;
  final String description;
  final String isoType;
  final String version;
  final String status;
  final String createdBy;
  final Timestamp createdAt;

  SurveyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isoType,
    required this.version,
    required this.status,
    required this.createdBy,
    required this.createdAt,
  });

  factory SurveyModel.fromMap(String id, Map<String, dynamic> map) {
    return SurveyModel(
      id: id,
      title: map['title'],
      description: map['description'],
      isoType: map['isoType'],
      version: map['version'],
      status: map['status'],
      createdBy: map['createdBy'],
      createdAt: map['createdAt'],
    );
  }
}