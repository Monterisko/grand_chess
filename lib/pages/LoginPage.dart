import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/MenuBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                    gradient: LinearGradient(colors: [
                  Color.fromRGBO(46, 42, 36, 1.0),
                  Color.fromRGBO(22, 21, 18, 1.0)
                ])),
                child: Column(
                  children: [
                    Text(
                      "Zaloguj się",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    Text(
                      "Nazwa użytkownika",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Wpisz nazwę użytkownika',
                      ),
                    ),
                    Text(
                      "Hasło",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Wpisz hasło',
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(46, 42, 36, 1.0),
                            fixedSize: Size(200, 50)),
                        child: Text(
                          "Zaloguj się",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
