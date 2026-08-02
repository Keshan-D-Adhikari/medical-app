import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPatient(String name, int age, String condition) async {
    await _db.collection('patients').add({
      'name': name,
      'age': age,
      'condition': condition,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getPatients() {
    return _db.collection('patients').snapshots();
  }
}
