import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';

final stockfishBot = Stockfish();

class BotHard {
  BotHard();

  final stockfishSub = stockfishBot.stdout.listen((message) {
    print('Stockfish: $message');
  });
}
