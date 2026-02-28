import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String employeeId;
  final String fullName;
  final String email;
  final String role;
  final String company;
  final String? sector;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.uid,
    required this.employeeId,
    required this.fullName,
    required this.email,
    required this.role,
    required this.company,
    this.sector,
    required this.isActive,
    required this.createdAt,
    this.lastLogin,
  });

  /// 🔹 Factory seguro desde Map
factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    uid: map['uid'] as String? ?? '',
    employeeId: map['employeeId'] as String? ?? '',
    fullName: map['fullName'] as String? ?? '',
    email: map['email'] as String? ?? '',
    role: map['role'] as String? ?? 'auditor',
    company: map['company'] as String? ?? '',
    sector: map['sector'] != null ? map['sector'] as String : null,
    isActive: map['isActive'] as bool? ?? false,
    createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    lastLogin: (map['lastLogin'] as Timestamp?)?.toDate(),
  );
}

  /// 🔹 Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'uid': uid,
      'employeeId': employeeId,
      'fullName': fullName,
      'email': email,
      'role': role,
      'company': company,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };

    if (sector != null) map['sector'] = sector;
    if (lastLogin != null) map['lastLogin'] = Timestamp.fromDate(lastLogin!);

    return map;
  }
}