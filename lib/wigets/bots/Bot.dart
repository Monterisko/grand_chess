import 'package:grand_chess/wigets/bots/BotEasy.dart';

import 'BotHard.dart';

class Bot {
  final String difficulty;
  final List<List<String?>> board;
  final Function() makeMove;
  Bot({required this.difficulty, required this.board, required this.makeMove});

  Object getBot(String difficulty) {
    switch (difficulty) {
      case "easy":
        return BotEasy(board: board, makeMove: makeMove);
      case "hard":
        return BotHard();
      default:
        return BotEasy(board: board, makeMove: makeMove);
    }
  }
}
