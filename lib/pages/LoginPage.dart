import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/auth/AuthError.dart';
import 'package:grand_chess/pages/HomePage.dart';
import 'package:grand_chess/pages/RegisterPage.dart';
import 'package:grand_chess/wigets/MenuBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _email;
  String? _password;
  AuthError error = AuthError(message: "", code: "");
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
                      height: 480,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(38, 36, 33, 1),
                      ),
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text("Zaloguj się",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30)),
                          ),
                          Text(
                            "Email:",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
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
                                  errorText: (error.code == 'invalid-email') ||
                                          (error.code == 'user-not-found')
                                      ? error.message
                                      : null),
                              onChanged: (value) {
                                _email = value;
                              },
                              style: TextStyle(color: Colors.white)),
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
                              errorText: error.code == 'invalid-credential'
                                  ? error.message
                                  : null,
                            ),
                            onChanged: (value) {
                              _password = value;
                            },
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                          ),
                          Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_email != null && _password != null) {
                                    signInWithEmailAndPassword(
                                            _email!, _password!, context)
                                        .then((userCredential) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ),
                                      );
                                    }).onError((e, stackTrace) {
                                      setState(() {
                                        error.message =
                                            "Wystąpił błąd logowania.";
                                      });
                                      if (e is FirebaseAuthException) {
                                        switch (e.code) {
                                          case 'user-not-found':
                                            setState(() {
                                              error.message =
                                                  "Nie znaleziono użytkownika o tym adresie e-mail.";
                                              error.code = 'user-not-found';
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
                                          default:
                                            setState(() {
                                              error.message =
                                                  e.message ?? error.message;
                                            });
                                            break;
                                        }
                                      }
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    fixedSize: Size(200, 50)),
                                child: Text(
                                  "Zaloguj się",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Zarejestruj się",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
