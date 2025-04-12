import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/components/User.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> addUser(String userID, String name) async {
  await _firestore.collection('users').doc(userID).set({'name': name});
}

Future<String> getUserNameFromDatabase(String id) async {
  DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
  if (doc.exists) {
    return doc['name'] as String;
  }
  return "Nieznany";
}

Future<void> deleteUser(String id) async {
  await _firestore.collection('users').doc(id).delete();
}

Future<User> fetchUser() async {
  return User(
      id: getUserId(), username: await getUserNameFromDatabase(getUserId()));
}
