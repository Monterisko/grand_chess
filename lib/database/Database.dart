import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/components/PGN.dart';
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

Future<Map<String, Map<String, dynamic>>> fetchAllGames() async {
  Map<String, Map<String, dynamic>> result = {};
  final snap = await _firestore.collection('users').doc(getUserId()).get();

  if (snap.exists) {
    final data = snap.data();
    if (data != null && data.containsKey("games")) {
      final games = data['games'];
      print(games);
    }
  }
  return result;
}
