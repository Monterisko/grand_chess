import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Game.dart';
import 'package:grand_chess/wigets/Move.dart';

Move getRandom(List<Move> legalMoves) {
  final random = Random();
  return legalMoves[random.nextInt(legalMoves.length)];
}

class BotEasy {
  final List<List<String?>> board;
  final Function(Move) makeMove;

  BotEasy({required this.board, required this.makeMove});

  void makeMoveAI() {
    List<Move> legalMoves = getLegalMovesForAI("black");

    if (legalMoves.isNotEmpty) {
      Move chosenMove = legalMoves[Random().nextInt(legalMoves.length)];
      makeMove(chosenMove);
    }
  }

  List<Move> getLegalMovesForAI(String color) {
    List<Move> legalMoves = [];
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] != null && board[i][j]!.startsWith(color)) {
          for (int k = 0; k < 8; k++) {
            for (int l = 0; l < 8; l++) {
              if (checkLegalMove(board, i, j, k, l)) {
                legalMoves.add(Move(
                    figure: board[i][j]!,
                    from: "${String.fromCharCode(97 + j)}${8 - i}",
                    to: "${String.fromCharCode(97 + l)}${8 - k}",
                    piece: Image.asset("assets/${board[i][j]}.png"),
                    isCapture: board[k][l] != null));
              }
            }
          }
        }
      }
    }
    return legalMoves;
  }
}
