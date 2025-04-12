import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:grand_chess/components/Dialog.dart';
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
  try {
    final credential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .whenComplete(() async {
      await addUser(_auth.currentUser!.uid, name);
    });
    credential.user!.updateDisplayName(name);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      showMessage(context, 'The password provided is too weak.', e.message!);
    } else if (e.code == 'email-already-in-use') {
      showMessage(
          context, 'The account already exists for that email.', e.message!);
    }
  } catch (e) {
    showMessage(context, "", e.toString());
  }
}

Future<void> signInWithEmailAndPassword(
    String email, String password, BuildContext context) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showMessage(context, 'No user found for that email.', e.message!);
    } else if (e.code == 'wrong-password') {
      showMessage(
          context, 'Wrong password provided for that user.', e.message!);
    }
  } catch (e) {
    showMessage(context, "", e.toString());
  }
}

Future<void> signOut() async {
  await _auth.signOut();
}
