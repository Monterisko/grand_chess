import 'package:firebase_auth/firebase_auth.dart';
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
    String name, String email, String password) async {
  try {
    final credential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .whenComplete(() async {
      await addUser(_auth.currentUser!.uid, name);
    });
    credential.user!.updateDisplayName(name);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

Future<void> signInWithEmailAndPassword(String email, String password) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  } catch (e) {
    print(e);
  }
}

Future<void> signOut() async {
  await _auth.signOut();
}
