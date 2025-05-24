import 'package:flutter/widgets.dart';
import 'package:grand_chess/Stockfish.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/database/Database.dart';
import 'package:grand_chess/wigets/BoardMove.dart';
import 'package:grand_chess/wigets/Game.dart';
import 'package:grand_chess/components/Move.dart';
import 'package:grand_chess/wigets/MoveList.dart';
import 'package:grand_chess/wigets/bots/Bot.dart';

final stockfishBot = Stockfish();

class BotHard extends Bot {
  VoidCallback update;
  BotHard(
      {super.difficulty = 'hard',
      required super.board,
      required super.makeMove,
      required this.update,
      context})
      : super(context: context);

  @override
  void executeMove(Move move, String? gameID) {
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
  void makeMoveAI(String gameID) {
    getBestMove(moves);
    Future.delayed(
      Duration(seconds: 1),
      () {
        List<String> text = stockfishBot.getBestMove().split(" ");
        String bestMoveUci = text[1];

        bool isCastling = bestMoveUci == 'e1g1' ||
            bestMoveUci == 'e1c1' ||
            bestMoveUci == 'e8g8' ||
            bestMoveUci == 'e8c8';
        if (isCastling) {
          String rookFrom, rookTo;

          switch (bestMoveUci) {
            case 'e1g1':
              rookFrom = 'h1';
              rookTo = 'f1';
              break;
            case 'e1c1':
              rookFrom = 'a1';
              rookTo = 'd1';
              break;
            case 'e8g8':
              rookFrom = 'h8';
              rookTo = 'f8';
              break;
            case 'e8c8':
              rookFrom = 'a8';
              rookTo = 'd8';
              break;
            default:
              return;
          }

          Move rookMove = Move(
            piece: Image.asset(
              "assets/${board[8 - int.parse(rookFrom[1])][rookFrom.codeUnitAt(0) - 97]}.png",
              scale: 1.8,
            ),
            from: rookFrom,
            to: rookTo,
            isCapture: false,
          );
          if (isUserLogged()) {
            updateGame(
              gameId: gameID,
              from: rookMove.from,
              to: rookMove.to,
              isCapture: rookMove.isCapture,
              color: 'black',
              piece: board[8 - int.parse(text[1][1])]
                  [text[1].codeUnitAt(0) - 97]!,
            );
          }
          executeMove(rookMove, null);
        }
        Move move = Move(
          piece: Image.asset(
            "assets/${board[8 - int.parse(text[1][1])][text[1].codeUnitAt(0) - 97]}.png",
            scale: 1.8,
          ),
          from: "${text[1].substring(0, 1)}${text[1].substring(1, 2)}",
          to: "${text[1].substring(2, 3)}${text[1].substring(3, 4)}",
          isCapture: board[8 - int.parse(text[1][3])]
                      [text[1].codeUnitAt(2) - 97] !=
                  null
              ? true
              : false,
        );
        if (isUserLogged()) {
          updateGame(
            gameId: gameID,
            from: move.from,
            to: move.to,
            isCapture: move.isCapture,
            color: 'black',
            piece: board[8 - int.parse(text[1][1])]
                [text[1].codeUnitAt(0) - 97]!,
          );
        }
        addMove(move);
        executeMove(move, null);

        stockfishBot.sendCommand(
            "position startpos moves ${moves.map((e) => e.from + e.to).join(' ')}");
        if (isCheckMate(board, "white")) {
          GameSettings settings =
              GameSettings(difficulty: "hard", isAgainstAI: true);
          checkmate(context, settings);
        }
        update();
      },
    );
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
