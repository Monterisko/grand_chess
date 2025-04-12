import 'package:flutter/material.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/pages/HomePage.dart';
import 'package:grand_chess/wigets/MenuBar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String? _name;
  late String? _email;
  late String? _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          menuBar(context),
          Expanded(
              child: Center(
            child: Container(
              width: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HSLColor.fromAHSL(1.0, 37.0, 0.07, 0.14).toColor()),
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text("Zarejestruj się",
                        style: TextStyle(color: Colors.white, fontSize: 30)),
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
                      style: TextStyle(color: Colors.white, fontSize: 20)),
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
                    ),
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
                              .whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            fixedSize: Size(200, 50)),
                        child: Text(
                          "Zarejestruj się",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
