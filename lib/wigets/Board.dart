import 'package:flutter/material.dart';

Widget createBoard() {
  return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      margin: const EdgeInsets.only(top: 30),
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {
          bool isWhite = (index ~/ 8 + index) % 2 == 0;
          return Container(
            color: isWhite ? Colors.white : Colors.brown,
          );
        },
        itemCount: 64,
      ));
}
