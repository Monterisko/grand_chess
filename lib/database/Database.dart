import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<bool> addUser(String name, String password) async {
  if (await getUserId(name) == null) {
    await _firestore.collection('users').add({
      'name': name,
      'password': password,
    });
    return true;
  }
  return false;
}

Future<List<QueryDocumentSnapshot<Object?>>> getUsers() async {
  QuerySnapshot querySnapshot = await _firestore.collection('users').get();
  return querySnapshot.docs;
}

Future<bool> checkUser(String name, String password) async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('users')
      .where('name', isEqualTo: name)
      .where('password', isEqualTo: password)
      .get();
  return querySnapshot.docs.isNotEmpty;
}

Future<String?> getUserId(String name) async {
  QuerySnapshot querySnapshot =
      await _firestore.collection('users').where('name', isEqualTo: name).get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.first.id;
  }
  return null;
}

Future<String?> getUserName(String id) async {
  DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
  if (doc.exists) {
    return doc['name'] as String?;
  }
  return null;
}

Future<void> deleteUser(String id) async {
  await _firestore.collection('users').doc(id).delete();
}
