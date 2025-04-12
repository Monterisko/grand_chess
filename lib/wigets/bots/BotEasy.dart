import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Game.dart';
import 'package:grand_chess/components/Move.dart';
import 'package:grand_chess/wigets/bots/Bot.dart';

Move getRandom(List<Move> legalMoves) {
  final random = Random();
  return legalMoves[random.nextInt(legalMoves.length)];
}

class BotEasy extends Bot {
  BotEasy(
      {required List<List<String?>> board,
      required Function() makeMove,
      required BuildContext context})
      : super(
            difficulty: 'easy',
            board: board,
            makeMove: makeMove,
            context: context);

  @override
  void makeMoveAI() {
    makeMove();
  }

  @override
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
                    piece: Image.asset(
                      "assets/${board[i][j]}.png",
                      scale: 1.8,
                    ),
                    isCapture: board[k][l] != null));
              }
            }
          }
        }
      }
    }
    return legalMoves;
  }

  @override
  void executeMove(Move move) {
    int fromRow = 8 - int.parse(move.from[1]);
    int fromCol = move.from.codeUnitAt(0) - 97;
    int toRow = 8 - int.parse(move.to[1]);
    int toCol = move.to.codeUnitAt(0) - 97;
    board[toRow][toCol] = board[fromRow][fromCol];
    board[fromRow][fromCol] = null;
  }
}

bool isMoveSafe(List<List<String?>> board, Move move, String botColor) {
  List<List<String?>> tempBoard = List.generate(8, (i) => List.from(board[i]));

  int fromRow = 8 - int.parse(move.from[1]);
  int fromCol = move.from.codeUnitAt(0) - 97;
  int toRow = 8 - int.parse(move.to[1]);
  int toCol = move.to.codeUnitAt(0) - 97;
  tempBoard[toRow][toCol] = tempBoard[fromRow][fromCol];
  tempBoard[fromRow][fromCol] = null;

  return !isCheck(tempBoard, botColor);
}
