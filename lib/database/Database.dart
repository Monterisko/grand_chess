import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/components/ModelGame.dart';
import 'package:grand_chess/components/Move.dart';
import 'package:grand_chess/components/User.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> addUser(String userID, String name) async {
  await _firestore.collection('users').doc(userID).set({'name': name});
}

Future<String> getUserNameFromDatabase(String? id) async {
  DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
  if (doc.exists) {
    return doc['name'] as String;
  }
  return "Nieznany";
}

Future<String?> getUsernameFromDatabase(String? id) async {
  DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
  if (doc.exists) {
    return doc['name'] as String;
  }
  return null;
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
      .orderBy('createdAt', descending: true)
      .get();

  return snap.docs.map((doc) => doc.data()).toList();
}

Stream<List<Map<String, dynamic>>> streamAllGames() {
  return _firestore
      .collection('users')
      .doc(getUserId())
      .collection('games')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
}

Future<String> createNewGame({
  required String whitePlayerId,
  required String gameType,
  String? blackPlayerId,
}) async {
  final newGameRef =
      _firestore.collection('users').doc(getUserId()).collection('games').doc();

  final newGame = ModelGame(
    id: newGameRef.id,
    gameType: gameType,
    whitePlayerId: whitePlayerId,
    blackPlayerId: blackPlayerId,
    players: [whitePlayerId],
    status: 'in_progress',
    currentTurn: 'white',
    moves: [],
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
  );

  await newGameRef.set(newGame.toMap());

  return newGame.id;
}

Future<void> updateGame({
  required String gameId,
  required String from,
  required String to,
  required bool isCapture,
  required String color,
  required String piece,
  String? status,
  String? result,
}) async {
  final move = {
    'from': from,
    'to': to,
    'isCapture': isCapture,
    'color': color,
    'piece': piece,
    'timestamp': formatTimestamp(Timestamp.now()),
  };

  final nextTurn = (color == 'white') ? 'black' : 'white';

  if (status != null) {
    await _firestore
        .collection('users')
        .doc(getUserId())
        .collection('games')
        .doc(gameId)
        .update(
      {
        'moves': FieldValue.arrayUnion([move]),
        'currentTurn': nextTurn,
        'updatedAt': FieldValue.serverTimestamp(),
        'result': result!,
        'status': status,
      },
    );
    formatUpdatedAt(gameId);
  } else {
    await _firestore
        .collection('users')
        .doc(getUserId())
        .collection('games')
        .doc(gameId)
        .update({
      'moves': FieldValue.arrayUnion([move]),
      'currentTurn': nextTurn,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    formatUpdatedAt(gameId);
  }
}

Future<void> deleteGame(String gameId) async {
  await _firestore
      .collection('users')
      .doc(getUserId())
      .collection('games')
      .doc(gameId)
      .delete();
}

String formatTimestamp(Timestamp timestamp) {
  Intl.systemLocale = "pl_PL";
  initializeDateFormatting("pl_PL");
  final date = timestamp.toDate();
  final formatter = DateFormat('dd.MM.yyyy, HH:mm');
  return formatter.format(date);
}

void formatUpdatedAt(gameId) async {
  final docSnap = await _firestore
      .collection('users')
      .doc(getUserId())
      .collection('games')
      .doc(gameId)
      .get();
  final data = docSnap.data();
  final Timestamp? updatedAt = data?['updatedAt'];
  await _firestore
      .collection('users')
      .doc(getUserId())
      .collection('games')
      .doc(gameId)
      .update({
    'updatedAt': formatTimestamp(updatedAt!),
  });
}

Future<List<Move>> fetchMoves(String gameId) async {
  List<Move> result = [];

  final docSnap = await _firestore
      .collection('users')
      .doc(getUserId())
      .collection('games')
      .doc(gameId)
      .get();

  final data = docSnap.data();
  for (var x in data!['moves']) {
    result.add(
      Move(
        from: x['from'],
        to: x['to'],
        isCapture: x['isCapture'],
        color: x['color'],
        figure: x['piece'],
        piece: Image.asset(
          "assets/${x['piece']}.png",
          scale: 1.8,
        ),
      ),
    );
  }
  return result;
}
