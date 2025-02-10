import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Pieces.dart';

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
          int row = index ~/ 8;
          int col = index % 8;

          bool isWhite = (index ~/ 8 + index) % 2 == 0;
          bool isRow2 = (row == 6);
          bool isRow7 = (row == 1);
          bool isA1orH1 = ((row == 7 && col == 0) || (row == 7 && col == 7));
          bool isA8orH8 = ((row == 0 && col == 0) || (row == 0 && col == 7));
          bool isB1orG1 = ((row == 7 && col == 1) || (row == 7 && col == 6));
          bool isB8orG8 = ((row == 0 && col == 1) || (row == 0 && col == 6));
          bool isC1orF1 = ((row == 7 && col == 2) || (row == 7 && col == 5));
          bool isC8orF8 = ((row == 0 && col == 2) || (row == 0 && col == 5));
          bool isD1 = (row == 7 && col == 3);
          bool isD8 = (row == 0 && col == 3);
          bool isE1 = (row == 7 && col == 4);
          bool isE8 = (row == 0 && col == 4);
          return Container(
            color: isWhite ? Colors.white : Colors.brown,
            child: isRow2
                ? whitePawn()
                : isRow7
                    ? blackPawn()
                    : isA1orH1
                        ? whiteRook()
                        : isA8orH8
                            ? blackRook()
                            : isB1orG1
                                ? whiteKnight()
                                : isB8orG8
                                    ? blackKnight()
                                    : isC1orF1
                                        ? whiteBishop()
                                        : isC8orF8
                                            ? blackBishop()
                                            : isD1
                                                ? whiteQueen()
                                                : isD8
                                                    ? blackQueen()
                                                    : isE1
                                                        ? whiteKing()
                                                        : isE8
                                                            ? blackKing()
                                                            : null,
          );
        },
        itemCount: 64,
      ));
}
