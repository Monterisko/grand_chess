import 'package:flutter/material.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/pages/HomePage.dart';
import 'package:grand_chess/pages/RegisterPage.dart';
import 'package:grand_chess/wigets/MenuBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String? _email;
  late String? _password;
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
                              ),
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
                                        .whenComplete(
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                      },
                                    );
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
