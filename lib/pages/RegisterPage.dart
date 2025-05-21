import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/auth/AuthError.dart';
import 'package:grand_chess/pages/HomePage.dart';
import 'package:grand_chess/wigets/MenuBar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthError error = AuthError(message: "", code: "");

  String? _name;
  String? _email;
  String? _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 118 / constraints.maxHeight],
                colors: [
                  Color.fromRGBO(46, 42, 36, 1),
                  Color.fromRGBO(22, 21, 18, 1)
                ],
              ),
            ),
            child: Column(
              children: [
                menuBar(context),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(38, 36, 33, 1),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        spacing: 20,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text("Zarejestruj się",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30)),
                          ),
                          Text(
                            "Nazwa użytkownika:",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Proszę wpisać nazwę użytkownika';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              hintText: 'Wpisz nazwę użytkownika',
                            ),
                            onChanged: (value) {
                              _name = value;
                            },
                            style: TextStyle(color: Colors.white),
                          ),
                          Text("Email:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Proszę wpisać email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                hintText: 'Wpisz email',
                                errorText:
                                    error.code == 'email-already-in-use' ||
                                            error.code == 'invalid-email'
                                        ? error.message
                                        : null),
                            onChanged: (value) {
                              _email = value;
                            },
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Hasło:",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Proszę wpisać hasło';
                              }
                              return null;
                            },
                            obscureText: true,
                            onChanged: (value) {
                              _password = value;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                hintText: 'Wpisz hasło',
                                errorText: error.code == 'weak-password'
                                    ? error.message
                                    : null),
                            style: TextStyle(color: Colors.white),
                          ),
                          Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_name == null ||
                                      _email == null ||
                                      _password == null) {
                                    return;
                                  }

                                  createAccountByPassword(
                                          _name!, _email!, _password!, context)
                                      .then((userCredential) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  }).onError((e, stackTrace) {
                                    setState(() {
                                      error.message =
                                          "Wystąpił błąd logowania.";
                                    });
                                    if (e is FirebaseAuthException) {
                                      switch (e.code) {
                                        case 'email-already-in-use':
                                          setState(() {
                                            error.message =
                                                "Podany email już isnieje.";
                                            error.code = 'email-already-in-use';
                                          });
                                          break;
                                        case 'invalid-credential':
                                          setState(() {
                                            error.message =
                                                "Nieprawidłowe hasło.";
                                            error.code = 'invalid-credential';
                                          });
                                          break;
                                        case 'invalid-email':
                                          setState(() {
                                            error.message =
                                                "Nieprawidłowy adres e-mail.";
                                            error.code = 'invalid-email';
                                          });
                                          break;
                                        case 'weak-password':
                                          setState(() {
                                            error.message = "Zbyt słabe hasło";
                                            error.code = 'weak-password';
                                          });
                                        default:
                                          setState(() {
                                            error.message =
                                                e.message ?? error.message;
                                          });
                                          break;
                                      }
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    fixedSize: Size(200, 50)),
                                child: Text(
                                  "Zarejestruj się",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
