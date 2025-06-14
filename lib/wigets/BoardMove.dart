import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/components/Dialog.dart';
import 'package:grand_chess/database/Database.dart';
import 'package:grand_chess/pages/HomePage.dart';
import 'package:grand_chess/wigets/Board.dart';
import 'package:grand_chess/wigets/MenuBar.dart';
import 'package:grand_chess/wigets/Game.dart';
import 'package:grand_chess/components/Move.dart';
import 'package:grand_chess/wigets/MoveList.dart';
import 'package:grand_chess/wigets/ResizableContainer.dart';
import 'package:grand_chess/wigets/bots/Bot.dart';
import 'package:grand_chess/wigets/bots/BotEasy.dart';
import 'package:grand_chess/wigets/bots/BotHard.dart';
import 'package:grand_chess/wigets/bots/BotMedium.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class BoardMove extends State<Board> {
  List<List<String?>> board = List.generate(8, (_) => List.filled(8, null));
  int? fromRow;
  int? fromCol;
  final ScrollController controller = ScrollController();
  late dynamic bot;
  late WebSocketChannel channel;
  late GameSettings settings;
  late String firebaseID;

  BoardMove();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 118 / constraints.maxHeight],
                colors: [
                  Color.fromRGBO(46, 42, 36, 1),
                  Color.fromRGBO(22, 21, 18, 1)
                ],
              ),
            ),
            child: Column(
              children: [
                menuBar(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    createBoard(
                      min(MediaQuery.of(context).size.width - 390, 800),
                    ),
                    displayMoves(controller),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 140),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        updateGame(
                          gameId: firebaseID,
                          from: "",
                          to: "",
                          isCapture: false,
                          piece: "",
                          color: currentTurn,
                          status: "finished",
                          result: currentTurn == "white" ? "0-1" : "1-0",
                        );
                        endGame(context, settings);
                      },
                      child: Text(
                        "Poddaj grę",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String turn = "white";
  String currentTurn = "white";

  String? myColor;
  int? gameId;

  Future<void> waitForGameId() async {
    channel.stream.listen(
      (message) {
        final data = json.decode(message);
        if (data["type"] == "game_id") {
          setState(
            () {
              gameId = data["game_id"];
            },
          );
        }
      },
      onError: (e) {},
    );

    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      return gameId == null;
    });
  }

  Future<void> waitForColor(data) async {
    if (data["type"] == "player_joined") {
      setState(() {
        myColor = data["color"];
      });
    }

    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      return myColor == null;
    });
  }

  Future<void> _createGame() async {
    if (isUserLogged()) {
      final id = await createNewGame(
        whitePlayerId: getUserId(),
        gameType: settings.difficulty,
        blackPlayerId: settings.difficulty == "player" ? getUserId() : null,
      );
      setState(() {
        firebaseID = id;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (!isUserLogged()) firebaseID = "";
    settings = widget.settings;
    _createGame();

    if (settings.isAgainstAI) {
      bot = Bot.createBot(settings, board, makeMove, updateBoard, context);
      if (settings.difficulty == "hard") {
        (bot as BotHard).endGame();
        (bot as BotHard).changeDifficulty("20");
      }
      if (settings.difficulty == "medium") {
        (bot as BotMedium).endGame();
        (bot as BotMedium).changeDifficulty("10");
      }
    }
    if (settings.isOnline) {
      channel = WebSocketChannel.connect(Uri.parse("ws://localhost:8000/ws"));
      channel.ready.onError(
        (error, stackTrace) {
          showMessage(
            context,
            "WebSocket Error",
            "Błąd łaczenia z WebSocketem",
            [
              play(context, Colors.black),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: Text(
                  "Powrót na strónę główną",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          );
        },
      );
      waitForGameId().then(
        (_) {
          channel.sink.close(status.normalClosure);
          channel = WebSocketChannel.connect(
              Uri.parse("ws://localhost:8000/ws/$gameId"));
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("Oczekiwanie na przeciwnika"),
                );
              });

          channel.stream.listen(
            (message) {
              final data = json.decode(message);
              if (data["type"] == "start_game") {
                Navigator.of(context).pop();
              }
              if (data["type"] == "end_game") {
                checkmate(context, settings);
              }
              if (data["type"] == "move") {
                setState(
                  () {
                    addMove(Move(
                        isCapture: data["isCapture"],
                        piece: Image.asset("assets/${data["figure"]}.png",
                            scale: 1.8),
                        from: data["from"],
                        to: data["to"]));
                    board[8 - int.parse(data["to"][1])]
                        [data["to"][0].codeUnitAt(0) - 97] = data["figure"];
                    board[8 - int.parse(data["from"][1])]
                        [data["from"][0].codeUnitAt(0) - 97] = null;
                    turn = (turn == "white") ? "black" : "white";
                  },
                );
              }
              waitForColor(data);
              if (data["type"] == "player_left") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Koniec gry"),
                      content: Text("Przeciwnik opuścił grę"),
                      actions: [
                        TextButton(
                          child: Text("Zagraj ponownie"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            clearMoves();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Board(
                                  settings: settings,
                                ),
                              ),
                            );
                          },
                        ),
                        TextButton(
                          child: Text("Powrót do menu"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          },
                        )
                      ],
                    );
                  },
                );
              }
            },
            onError: (e) {},
          );
        },
      );
    }
    initializeBoard();
  }

  void updateBoard() {
    setState(() {});
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

  void flipBoard() {
    setState(() {
      board = board.reversed.toList();
      for (int i = 0; i < 8; i++) {
        board[i] = board[i].reversed.toList();
      }
    });
  }

  Widget createBoard([double? maxSize]) {
    return ResizableContainer(
      initSize: 400,
      minSize: 400,
      maxSize: maxSize ?? 800,
      child: Center(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemBuilder: (BuildContext context, int index) {
              int toRow = index ~/ 8;
              int toCol = index % 8;
              if (settings.isOnline) {
                if (myColor == "black") {
                  toRow = 7 - toRow;
                  toCol = 7 - toCol;
                }
              }
              if (settings.isHotseat) {
                if (currentTurn == "black") {
                  toRow = 7 - toRow;
                  toCol = 7 - toCol;
                }
              }
              bool isSelected = (toRow == fromRow && toCol == fromCol);
              return GestureDetector(
                onTap: () => settings.isAgainstAI
                    ? onMoveWithAI(board, toRow, toCol)
                    : settings.isOnline
                        ? onMoveOnline(toRow, toCol)
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
          ),
        ),
      ),
    );
  }

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
            updateGame(
              gameId: firebaseID,
              from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
              to: "${String.fromCharCode(97 + toCol)}${8 - toRow}",
              isCapture: move != null ? true : false,
              piece: board[fromRow!][fromCol!]!,
              color: currentTurn,
              status: "finished",
              result: currentTurn == "white" ? "1-0" : "0-1",
            );
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Koniec gry"),
                    content: Text("Szach mat"),
                    actions: [
                      TextButton(
                        child: Text("Zagraj ponownie"),
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
                      ),
                      TextButton(
                        child: Text("Powrót do menu"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          clearMoves();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
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
        addMove(
          Move(
            isCapture: move != null ? true : false,
            piece: Image.asset(
              "assets/${board[toRow][toCol]}.png",
              scale: 1.8,
            ),
            from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
            to: "${String.fromCharCode(97 + toCol)}${8 - toRow}",
          ),
        );
        if (isUserLogged()) {
          updateGame(
            gameId: firebaseID,
            from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
            to: "${String.fromCharCode(97 + toCol)}${8 - toRow}",
            isCapture: move != null ? true : false,
            color: currentTurn,
            piece: board[toRow][toCol]!,
          );
        }
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
            checkmate(context, settings);
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
          to: "${String.fromCharCode(97 + toCol)}${8 - toRow}",
        );
        addMove(
          Move(
            isCapture: move != null,
            piece: Image.asset(
              "assets/${board[toRow][toCol]}.png",
              scale: 1.8,
            ),
            from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
            to: "${String.fromCharCode(97 + toCol)}${8 - toRow}",
          ),
        );
        if (isUserLogged()) {
          updateGame(
            gameId: firebaseID,
            from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
            to: "${String.fromCharCode(97 + toCol)}${8 - toRow}",
            isCapture: move != null ? true : false,
            color: currentTurn,
            piece: board[toRow][toCol]!,
          );
        }
        fromRow = null;
        fromCol = null;

        if (bot is BotEasy) {
          makeMove(firebaseID);
        }
        if (bot is BotHard) {
          (bot as BotHard).getBestMove(moves);
          setState(() {
            (bot as BotHard).makeMoveAI(firebaseID);
          });
        }
        if (bot is BotMedium) {
          (bot as BotMedium).getBestMove(moves);
          setState(() {
            (bot as BotMedium).makeMoveAI(firebaseID);
          });
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

  Future<void> onMoveOnline(int toRow, int toCol) async {
    if (myColor != turn) {
      return;
    }
    setState(() {
      String? move = board[toRow][toCol];

      if (fromRow == null && fromCol == null) {
        if (move != null) {
          fromRow = toRow;
          fromCol = toCol;
          if (!(myColor == "white" &&
                  board[fromRow!][fromCol!]!.startsWith("white")) &&
              !(myColor == "black" &&
                  board[toRow][toCol]!.startsWith("black"))) {
            fromRow = null;
            fromCol = null;
          }
        }
      } else {
        if ((myColor == "white" &&
                board[fromRow!][fromCol!]!.startsWith("white")) ||
            (myColor == "black" &&
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

          if (isCheck(board, myColor!)) {
            board[toRow][toCol] = move;
            board[fromRow!][fromCol!] = target;
            return;
          }
          if (isCheckMate(board, myColor == "white" ? "black" : "white")) {
            channel.sink.add(json.encode({
              "type": "end_game",
            }));
          }
        }
        previousMove = Move(
          color: turn,
          figure: board[toRow][toCol]!,
          isCapture: move != null ? true : false,
          piece: Image.asset(
            "assets/${board[toRow][toCol]}.png",
            scale: 1.8,
          ),
          from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
          to: "${String.fromCharCode(97 + toCol)}${8 - toRow}",
        );
        if (isUserLogged()) {
          updateGame(
            gameId: firebaseID,
            from: "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
            to: "${String.fromCharCode(97 + toCol)}${8 - toRow}",
            isCapture: move != null ? true : false,
            color: turn,
            piece: board[toRow][toCol]!,
          );
        }
        channel.sink.add(json.encode({
          "type": "move",
          "from": "${String.fromCharCode(97 + fromCol!)}${8 - fromRow!}",
          "to": "${String.fromCharCode(97 + toCol)}${8 - toRow}",
          "figure": previousMove.figure,
          "isCapture": previousMove.isCapture
        }));
        fromRow = null;
        fromCol = null;
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

  void makeMove(String? gameID) {
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
        bot.executeMove(move, gameID);
        return;
      }
    }
    if (legalMoves.isNotEmpty) {
      Move move = legalMoves[Random().nextInt(legalMoves.length)];
      addMove(move);
      bot.executeMove(move, gameID);
    }
  }
}

void checkmate(BuildContext context, GameSettings settings) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Koniec gry"),
          content: Text("Szach mat"),
          actions: [
            TextButton(
              child: Text("Zagraj ponownie"),
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
            ),
            TextButton(
              child: Text("Powrót do menu"),
              onPressed: () {
                Navigator.of(context).pop();
                clearMoves();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            )
          ],
        );
      });
}

void endGame(BuildContext context, GameSettings settings) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Koniec gry"),
          content: Text("Poddałeś się"),
          actions: [
            TextButton(
              child: Text("Zagraj ponownie"),
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
            ),
            TextButton(
              child: Text("Powrót do menu"),
              onPressed: () {
                Navigator.of(context).pop();
                clearMoves();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            )
          ],
        );
      });
}
