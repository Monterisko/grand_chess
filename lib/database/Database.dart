import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/components/User.dart';
import 'package:web/web.dart';

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

Future<List<Map<String, dynamic>>> fetchAllGames() async {
  List<Map<String, dynamic>> result = [];
  final snap = await _firestore
      .collection('users')
      .doc(getUserId())
      .collection('games')
      .get();
  final docs = snap.docs;
  for (var doc in docs) {
    result.add(doc.data());
  }
  return result;
}

Future<void> updateGamesCollection(
    String gameID, Map<String, dynamic> data) async {
  final snap = await _firestore
      .collection('users')
      .doc(getUserId())
      .collection('games')
      .doc(gameID)
      .update(data);
}

Future<void> addToGamesCollection(Map<String, dynamic> data) async {
  final snap = await _firestore
      .collection('users')
      .doc(getUserId())
      .collection('games')
      .add(data);
}

Future<String> findGameID(int id) async {
  final snap = await _firestore
      .collection('users')
      .doc(getUserId())
      .collection('games')
      .get();

  for (var i = 0; i < snap.docs.length; i++) {
    if (id == i) {
      return snap.docs[i].id;
    }
  }
  return "";
}
