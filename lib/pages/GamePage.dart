import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Board.dart';
import 'package:grand_chess/wigets/MenuBar.dart';

Widget createGame(context) {
  return Scaffold(
    backgroundColor: Colors.grey,
    body: Column(children: [menuBar(context), createBoard()]),
  );
}
