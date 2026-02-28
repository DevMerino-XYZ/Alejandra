import 'package:cloud_firestore/cloud_firestore.dart';

class ScaleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getScales() {
    return _db.collection('scales').snapshots();
  }

  Future<void> createScale(Map<String, dynamic> data) async {
    await _db.collection('scales').add(data);
  }
}