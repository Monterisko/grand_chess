import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(String userId, String name, String email) async {
    await _firestore.collection('users').doc(userId).set({
      'name': name,
      'email': email,
    });
  }

  Future<Map<String, dynamic>?> getUsers() async {
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    querySnapshot.docs.forEach((doc) {
      print('${doc.id} => ${doc.data()}');
    });
    return null;
  }
}
