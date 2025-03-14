import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Board.dart';
import 'package:grand_chess/wigets/MenuBar.dart';
import 'package:grand_chess/wigets/Game.dart';
import 'package:grand_chess/wigets/Move.dart';
import 'package:grand_chess/wigets/MoveList.dart';
import 'package:grand_chess/wigets/bots/Bot.dart';
import 'package:grand_chess/wigets/bots/BotEasy.dart';
import 'package:grand_chess/wigets/bots/BotHard.dart';

class BoardMove extends State<Board> {
  List<List<String?>> board = List.generate(8, (_) => List.filled(8, null));
  int? fromRow;
  int? fromCol;
  late var bot;
  BotSettings settings;

  BoardMove({required this.settings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(children: [
        menuBar(context),
        Row(children: [createBoard(), Expanded(child: displayMoves())])
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeBoard();
    if (settings.isAgainstAI) {
      bot = Bot.createBot(settings, board, makeMove);
      if (settings.difficulty == "hard") {
        (bot as BotHard).endGame();
        (bot as BotHard).changeDifficulty("20");
      }
    }
  }

  void initializeBoard() {
    board[7][0] = "white_rook";
    board[7][1] = "white_knight";
    board[7][2] = "white_bishop";
    board[7][3] = "white_queen";
    board[7][4] = "white_king";
    board[7][5] = "white_bishop";
    board[7][6] = "white_knight";
    board[7][7] = "white_rook";
    for (int i = 0; i < 8; i++) {
      board[6][i] = "white_pawn";
    }
    board[0][0] = "black_rook";
    board[0][1] = "black_knight";
    board[0][2] = "black_bishop";
    board[0][3] = "black_queen";
    board[0][4] = "black_king";
    board[0][5] = "black_bishop";
    board[0][6] = "black_knight";
    board[0][7] = "black_rook";
    for (int i = 0; i < 8; i++) {
      board[1][i] = "black_pawn";
    }
  }

  Widget createBoard() {
    return Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        margin: const EdgeInsets.only(top: 30),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
          itemBuilder: (BuildContext context, int index) {
            int toRow = index ~/ 8;
            int toCol = index % 8;
            bool isSelected = (toRow == fromRow && toCol == fromCol);
            return GestureDetector(
              onTap: () => settings.isAgainstAI
                  ? onMoveWithAI(board, toRow, toCol)
                  : onMove(board, toRow, toCol),
              child: Container(
                decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green
                        : (toRow + toCol) % 2 == 0
                            ? Colors.white
                            : const Color.fromARGB(255, 159, 86, 60),
                    border: Border.all(color: Colors.black)),
                child: board[toRow][toCol] != null
                    ? Image.asset('assets/${board[toRow][toCol]}.png')
                    : null,
              ),
            );
          },
          itemCount: 64,
        ));
  }

  String currentTurn = "white";
  static bool castleW = true;
  static bool castleB = true;
  Move previousMove = Move(from: "", to: "", piece: Image.asset(""));
  Future<void> onMove(List<List<String?>> board, int toRow, int toCol) async {
    setState(() {
      String? move = board[toRow][toCol];
      if (fromRow == null && fromCol == null) {
        if (board[toRow][toCol] != null) {
          fromRow = toRow;
          fromCol = toCol;
          if (!(currentTurn == "white" &&
                  board[fromRow!][fromCol!]!.startsWith("white")) &&
              !(currentTurn == "black" &&
                  board[toRow][toCol]!.startsWith("black"))) {
            fromRow = null;
            fromCol = null;
          }
        }
      } else {
        if ((currentTurn == "white" &&
                board[fromRow!][fromCol!]!.startsWith("white")) ||
            (currentTurn == "black" &&
                board[fromRow!][fromCol!]!.startsWith("black"))) {
          if (toRow == fromRow && toCol == fromCol) {
            fromRow = null;
            fromCol = null;
            return;
          }
          if (!checkEnPassant(
              board, fromRow!, fromCol!, toRow, toCol, previousMove)) {
            if (!checkLegalMove(board, fromRow!, fromCol!, toRow, toCol)) {
              return;
            }
          } else {
            if (board[fromRow!][fromCol!]!.startsWith("white")) {
              board[toRow + 1][toCol] = null;
            } else {
              board[toRow - 1][toCol] = null;
            }
          }
          String? target = board[fromRow!][fromCol!];

          board[toRow][toCol] = board[fromRow!][fromCol!];
          board[fromRow!][fromCol!] = null;

          if (isCheck(board, currentTurn)) {
            board[toRow][toCol] = move;
            board[fromRow!][fromCol!] = target;
            return;
          }
          if (isCheckMate(board, currentTurn == "white" ? "black" : "white")) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Koniec gry"),
                    content: Text("Szach mat"),
                    actions: [
                      TextButton(
                        child: Text("Zamknij"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          clearMoves();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Board(
                                        settings: settings,
                                      )));
                        },
                      )
                    ],
                  );
                });
          }
        }
        previousMove = Move(
            color: currentTurn,
            figure: board[toRow][toCol]!,
            isCapture: move != null,
            piece: Image.asset(
              "assets/${board[toRow][toCol]}.png",
              scale: 1.8,
            ),
            from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
            to: "${String.fromCharCode(97 + toCol)}${8 - toRow}");
        addMove(Move(
            isCapture: move != null,
            piece: Image.asset(
              "assets/${board[toRow][toCol]}.png",
              scale: 1.8,
            ),
            from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
            to: "${String.fromCharCode(97 + toCol)}${8 - toRow}"));
        fromRow = null;
        fromCol = null;
        currentTurn = currentTurn == "white" ? "black" : "white";
      }
    });
    if ((board[toRow][toCol] == "white_pawn" && toRow == 0) ||
        (board[toRow][toCol] == "black_pawn" && toRow == 7)) {
      showPromotionDialog(context, board[toRow][toCol]!.split("_")[0])
          .then((promotedPiece) {
        if (promotedPiece != null) {
          setState(() {
            board[toRow][toCol] = promotedPiece;
          });
        }
      });
    }
  }

  Future<void> onMoveWithAI(
      List<List<String?>> board, int toRow, int toCol) async {
    setState(() {
      String? move = board[toRow][toCol];
      if (fromRow == null && fromCol == null) {
        if (board[toRow][toCol] != null) {
          fromRow = toRow;
          fromCol = toCol;
          if (!(currentTurn == "white" &&
                  board[fromRow!][fromCol!]!.startsWith("white")) &&
              !(currentTurn == "black" &&
                  board[toRow][toCol]!.startsWith("black"))) {
            fromRow = null;
            fromCol = null;
          }
        }
      } else {
        if ((currentTurn == "white" &&
                board[fromRow!][fromCol!]!.startsWith("white")) ||
            (currentTurn == "black" &&
                board[fromRow!][fromCol!]!.startsWith("black"))) {
          if (toRow == fromRow && toCol == fromCol) {
            fromRow = null;
            fromCol = null;
            return;
          }
          if (!checkEnPassant(
              board, fromRow!, fromCol!, toRow, toCol, previousMove)) {
            if (!checkLegalMove(board, fromRow!, fromCol!, toRow, toCol)) {
              return;
            }
          } else {
            if (board[fromRow!][fromCol!]!.startsWith("white")) {
              board[toRow + 1][toCol] = null;
            } else {
              board[toRow - 1][toCol] = null;
            }
          }
          String? target = board[fromRow!][fromCol!];

          board[toRow][toCol] = board[fromRow!][fromCol!];
          board[fromRow!][fromCol!] = null;

          if (isCheck(board, currentTurn)) {
            board[toRow][toCol] = move;
            board[fromRow!][fromCol!] = target;
            return;
          }
          if (isCheckMate(board, currentTurn == "white" ? "black" : "white")) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Koniec gry"),
                    content: Text("Szach mat"),
                    actions: [
                      TextButton(
                        child: Text("Zamknij"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          clearMoves();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Board(
                                        settings: settings,
                                      )));
                        },
                      )
                    ],
                  );
                });
          }
        }
        previousMove = Move(
            color: currentTurn,
            figure: board[toRow][toCol]!,
            isCapture: move != null,
            piece: Image.asset(
              "assets/${board[toRow][toCol]}.png",
              scale: 1.8,
            ),
            from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
            to: "${String.fromCharCode(97 + toCol)}${8 - toRow}");
        addMove(Move(
            isCapture: move != null,
            piece: Image.asset(
              "assets/${board[toRow][toCol]}.png",
              scale: 1.8,
            ),
            from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
            to: "${String.fromCharCode(97 + toCol)}${8 - toRow}"));
        fromRow = null;
        fromCol = null;
        if (bot is BotEasy) {
          makeMove();
        }
        if (bot is BotHard) {
          (bot as BotHard).getBestMove(moves);
          (bot as BotHard).makeMoveAI();
        }
      }
    });
    if ((board[toRow][toCol] == "white_pawn" && toRow == 0) ||
        (board[toRow][toCol] == "black_pawn" && toRow == 7)) {
      showPromotionDialog(context, board[toRow][toCol]!.split("_")[0])
          .then((promotedPiece) {
        if (promotedPiece != null) {
          setState(() {
            board[toRow][toCol] = promotedPiece;
          });
        }
      });
    }
  }

  void makeMove() {
    List<Move> legalMoves = bot.getLegalMovesForAI("black");
    if (isCheck(board, "black")) {
      legalMoves.where((move) => isMoveSafe(board, move, "black")).toList();
      if (isCheck(board, "black")) {
        List<Move> safeMoves = legalMoves
            .where((move) => isMoveSafe(board, move, "black"))
            .toList();

        if (safeMoves.isEmpty) {
          return;
        }
        Move move = safeMoves[Random().nextInt(safeMoves.length)];
        addMove(move);
        bot.executeMove(move);
        return;
      }
    }
    if (legalMoves.isNotEmpty) {
      Move move = legalMoves[Random().nextInt(legalMoves.length)];
      addMove(move);
      bot.executeMove(move);
    }
  }
}
