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
    // Campos obligatorios con nullable primero
    final uid = map['uid'] as String?;
    final employeeId = map['employeeId'] as String?;
    final fullName = map['fullName'] as String?;
    final email = map['email'] as String?;
    final role = map['role'] as String?;
    final company = map['company'] as String?;

    if (uid == null ||
        employeeId == null ||
        fullName == null ||
        email == null ||
        role == null ||
        company == null) {
      throw Exception(
          "UserModel.fromMap: missing required fields in Firestore document");
    }

    return UserModel(
      uid: uid,
      employeeId: employeeId,
      fullName: fullName,
      email: email,
      role: role,
      company: company,
      sector: map['sector'] != null ? map['sector'] as String : null,
      isActive: map['isActive'] as bool? ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate(),
    );
  }

  /// 🔹 Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    final map = {
      'uid': uid,
      'employeeId': employeeId,
      'fullName': fullName,
      'email': email,
      'role': role,
      'company': company,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };

    // Variables locales para evitar error de promoción de campo público
    final sectorValue = sector;
    if (sectorValue != null) {
      map['sector'] = sectorValue;
    }

    final lastLoginValue = lastLogin;
    if (lastLoginValue != null) {
      map['lastLogin'] = Timestamp.fromDate(lastLoginValue);
    }

    return map;
  }
}