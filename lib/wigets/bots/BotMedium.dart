import 'package:flutter/material.dart';
import 'package:grand_chess/Stockfish.dart';
import 'package:grand_chess/wigets/BoardMove.dart';
import 'package:grand_chess/wigets/Game.dart';
import 'package:grand_chess/wigets/Move.dart';
import 'package:grand_chess/wigets/MoveList.dart';
import 'package:grand_chess/wigets/bots/Bot.dart';

final stockfishBot = Stockfish();

class BotMedium extends Bot {
  VoidCallback update;
  BotMedium(
      {super.difficulty = 'medium',
      required super.board,
      required super.makeMove,
      required this.update,
      context})
      : super(context: context);

  @override
  void executeMove(Move move) {
    int fromRow = 8 - int.parse(move.from[1]);
    int fromCol = move.from.codeUnitAt(0) - 97;
    int toRow = 8 - int.parse(move.to[1]);
    int toCol = move.to.codeUnitAt(0) - 97;
    board[toRow][toCol] = board[fromRow][fromCol];
    board[fromRow][fromCol] = null;
  }

  @override
  List<Move> getLegalMovesForAI(String color) {
    return [];
  }

  @override
  void makeMoveAI() {
    getBestMove(moves);
    Future.delayed(Duration(seconds: 1), () {
      List<String> text = stockfishBot.getBestMove().split(" ");
      Move move = Move(
          piece: Image.asset(
            "assets/${board[8 - int.parse(text[1][1])][text[1].codeUnitAt(0) - 97]}.png",
            scale: 1.8,
          ),
          from: "${text[1].substring(0, 1)}${text[1].substring(1, 2)}",
          to: "${text[1].substring(2, 3)}${text[1].substring(3, 4)}");

      addMove(move);
      executeMove(move);
      stockfishBot.sendCommand(
          "position startpos moves ${moves.map((e) => e.from + e.to).join(' ')}");
      if (isCheckMate(board, "white")) {
        GameSettings settings =
            GameSettings(difficulty: "medium", isAgainstAI: true);
        checkmate(context, settings);
      }
      update();
    });
  }

  void getBestMove(List<Move> moves) {
    stockfishBot.sendCommand(
        "position startpos moves ${moves.map((e) => e.from + e.to).join(' ')}");
    stockfishBot.sendCommand("go movetime 10");
  }

  void changeDifficulty(String difficulty) {
    stockfishBot.sendCommand('setoption name Skill Level value $difficulty');
  }

  void endGame() {
    stockfishBot.sendCommand('ucinewgame');
  }
}
