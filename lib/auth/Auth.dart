import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:grand_chess/database/Database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

bool isUserLogged() {
  if (_auth.currentUser != null) {
    return true;
  } else {
    return false;
  }
}

String getUserId() {
  String userId = _auth.currentUser!.uid;
  return userId;
}

Future<void> createAccountByPassword(
    String name, String email, String password, BuildContext context) async {
  final credential = await _auth
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((userCredential) async {
    await addUser(_auth.currentUser!.uid, name);
  });
  credential.user!.updateDisplayName(name);
}

Future<void> signInWithEmailAndPassword(
    String email, String password, BuildContext context) async {
  final credential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
}

Future<void> signOut() async {
  await _auth.signOut();
}
