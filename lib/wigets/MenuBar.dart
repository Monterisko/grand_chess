import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Board.dart';
import 'package:grand_chess/wigets/MoveList.dart';
import 'package:grand_chess/wigets/bots/Bot.dart';

Widget menuBar(context) {
  return Container(
    color: Colors.grey[800],
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
      ],
    ),
  );
}

Widget play(context) {
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
                                    settings:
                                        GameSettings(difficulty: "player"),
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
    child: Text('Nowa Gra', style: TextStyle(color: Colors.white)),
  );
}
