import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Move.dart';

List<Move> moves = [];

Widget displayMoves() {
  return Container(
      margin: const EdgeInsets.only(left: 40),
      child: Column(
        children: [
          for (int i = 0; i < moves.length; i = i + 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    children: [
                      moves[i].piece,
                      Text(moves[i].isCapture
                          ? "${moves[i].from.substring(0, moves[i].from.length - 1)}x${moves[i].to}"
                          : moves[i].to),
                    ],
                  ),
                ),
                if (i + 1 < moves.length)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      children: [
                        moves[i + 1].piece,
                        Text(moves[i + 1].isCapture
                            ? "${moves[i + 1].from.substring(0, moves[i + 1].from.length - 1)}x${moves[i + 1].to}"
                            : moves[i + 1].to),
                      ],
                    ),
                  )
              ],
            )
        ],
      ));
}

void addMove(Move move) {
  moves.add(move);
}

void clearMoves() {
  moves.clear();
}
