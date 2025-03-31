import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Move.dart';
import 'package:grand_chess/wigets/bots/BotEasy.dart';
import 'package:grand_chess/wigets/bots/BotMedium.dart';

import 'BotHard.dart';

abstract class Bot {
  final String difficulty;
  BuildContext context;
  final List<List<String?>> board;
  final Function() makeMove;
  Bot(
      {required this.difficulty,
      required this.board,
      required this.makeMove,
      required this.context});

  factory Bot.createBot(GameSettings settings, List<List<String?>> board,
      Function() makeMove, Function() update, BuildContext context) {
    switch (settings.difficulty) {
      case "easy":
        return BotEasy(board: board, makeMove: makeMove, context: context);
      case "medium":
        return BotMedium(
            board: board, makeMove: makeMove, update: update, context: context);
      case "hard":
        return BotHard(
            board: board, makeMove: makeMove, update: update, context: context);
      default:
        return BotEasy(board: board, makeMove: makeMove, context: context);
    }
  }

  void makeMoveAI();
  List<Move> getLegalMovesForAI(String color);
  void executeMove(Move move);
}

class GameSettings {
  final String difficulty;
  final bool isAgainstAI;
  final bool isOnline;
  GameSettings(
      {required this.difficulty,
      this.isAgainstAI = false,
      this.isOnline = false});
}
