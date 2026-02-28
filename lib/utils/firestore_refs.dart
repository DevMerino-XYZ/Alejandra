import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRefs {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference get users => _db.collection('users');
  static CollectionReference get scales => _db.collection('scales');
  static CollectionReference get surveys => _db.collection('surveys');
  static CollectionReference get inspections => _db.collection('inspections');
}