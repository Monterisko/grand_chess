import 'package:grand_chess/Stockfish.dart';
import 'package:grand_chess/wigets/Move.dart';
import 'package:grand_chess/wigets/bots/Bot.dart';

final stockfishBot = Stockfish();

class BotHard extends Bot {
  BotHard(
      {super.difficulty = 'hard',
      required super.board,
      required super.makeMove});

  @override
  void executeMove(Move move) {}

  @override
  List<Move> getLegalMovesForAI(String color) {
    return [];
  }

  @override
  void makeMoveAI() {}

  void getBestMove(String moves) {
    stockfishBot.sendCommand("position startpos moves $moves");
    stockfishBot.sendCommand("go depth 10");
  }
}
