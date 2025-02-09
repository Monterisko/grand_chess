import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Board.dart';

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
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  child: Text("vs Computer",
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(
                                  backgroundColor: Colors.grey,
                                  body: Column(
                                    children: [menuBar(context), createBoard()],
                                  ),
                                )));
                  },
                )
              ],
            );
          });
    },
    child: Text('Nowa Gra', style: TextStyle(color: Colors.white)),
  );
}
