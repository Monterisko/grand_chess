import 'package:flutter/material.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/components/User.dart';
import 'package:grand_chess/database/Database.dart';
import 'package:grand_chess/pages/HistoryPage.dart';
import 'package:grand_chess/pages/HomePage.dart';
import 'package:grand_chess/pages/LoginPage.dart';
import 'package:grand_chess/wigets/Board.dart';
import 'package:grand_chess/wigets/MoveList.dart';
import 'package:grand_chess/wigets/bots/Bot.dart';

late User user;
Widget menuBar(context) {
  return FutureBuilder(
      future: fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          user = snapshot.data!;
          return Container(
            color: Colors.transparent,
            height: 60,
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              spacing: 20,
              children: [
                Text(
                  'GrandChess',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                play(context),
                Expanded(child: Container()),
                if (isUserLogged())
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.grey[800],
                      value: user.getUserName(),
                      items: [
                        DropdownMenuItem(
                            value: user.getUserName(),
                            child: Text(
                              user.getUserName(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                        DropdownMenuItem(
                          value: "Historia gier",
                          child: Text(
                            "Historia gier",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Wyloguj się",
                          child: Text(
                            "Wyloguj się",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                      onChanged: (value) {
                        if (value == "Historia gier") {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HistoryPage()));
                        } else if (value == "Wyloguj się") {
                          signOut().whenComplete(() {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          });
                        }
                      },
                    ),
                  ),
                Container(
                  width: 20,
                )
              ],
            ),
          );
        } else {
          return Container(
            color: Colors.transparent,
            height: 60,
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              spacing: 20,
              children: [
                Text(
                  'GrandChess',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                play(context),
                Expanded(child: Container()),
                TextButton(
                  child: Text("Zaloguj się",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                ),
              ],
            ),
          );
        }
      });
}

Widget play(context, [Color? color]) {
  return TextButton(
    onPressed: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Rozpocznij nową grę"),
              content: Column(
                spacing: 30,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: Text("vs Komputer",
                        style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Wybierz poziom trudności"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 30,
                                children: [
                                  TextButton(
                                    child: Text("Łatwy",
                                        style: TextStyle(color: Colors.black)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      clearMoves();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Board(
                                                    settings: GameSettings(
                                                        difficulty: "easy",
                                                        isAgainstAI: true),
                                                  )));
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Średni",
                                        style: TextStyle(color: Colors.black)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      clearMoves();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Board(
                                                    settings: GameSettings(
                                                        difficulty: "medium",
                                                        isAgainstAI: true),
                                                  )));
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Trudny",
                                        style: TextStyle(color: Colors.black)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      clearMoves();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Board(
                                                    settings: GameSettings(
                                                        difficulty: "hard",
                                                        isAgainstAI: true),
                                                  )));
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                  TextButton(
                    child:
                        Text("vs Gracz", style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      clearMoves();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Board(
                                    settings: GameSettings(
                                        difficulty: "player", isOnline: true),
                                  )));
                    },
                  ),
                  TextButton(
                    child: Text("vs Gracz (Hotseat)",
                        style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      clearMoves();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Board(
                                    settings: GameSettings(
                                        difficulty: "local", isHotseat: true),
                                  )));
                    },
                  ),
                  TextButton(
                    child:
                        Text("Anuluj", style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          });
    },
    child: Text('Nowa Gra', style: TextStyle(color: color ?? Colors.white)),
  );
}
