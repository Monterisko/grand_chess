import 'package:grand_chess/wigets/Move.dart';
import 'package:grand_chess/wigets/bots/BotEasy.dart';

import 'BotHard.dart';

abstract class Bot {
  final String difficulty;
  final List<List<String?>> board;
  final Function() makeMove;
  Bot({required this.difficulty, required this.board, required this.makeMove});

  factory Bot.createBot(
      BotSettings settings, List<List<String?>> board, Function() makeMove) {
    switch (settings.difficulty) {
      case "easy":
        return BotEasy(board: board, makeMove: makeMove);
      case "hard":
        return BotHard(board: board, makeMove: makeMove);
      default:
        return BotEasy(board: board, makeMove: makeMove);
    }
  }

  void makeMoveAI();
  List<Move> getLegalMovesForAI(String color);
  void executeMove(Move move);
}

class BotSettings {
  final String difficulty;
  final bool isAgainstAI;
  BotSettings({required this.difficulty, required this.isAgainstAI});
}
