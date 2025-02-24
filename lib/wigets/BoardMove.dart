import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Board.dart';
import 'package:grand_chess/wigets/MenuBar.dart';
import 'package:grand_chess/wigets/Game.dart';
import 'package:grand_chess/wigets/Move.dart';
import 'package:grand_chess/wigets/MoveList.dart';

class BoardMove extends State<Board> {
  List<List<String?>> board = List.generate(8, (_) => List.filled(8, null));
  int? selectedRow;
  int? selectedCol;

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
            int row = index ~/ 8;
            int col = index % 8;
            bool isSelected = (row == selectedRow && col == selectedCol);
            return GestureDetector(
              onTap: () => onMove(board, row, col),
              child: Container(
                decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green
                        : (row + col) % 2 == 0
                            ? Colors.white
                            : Colors.brown[400],
                    border: Border.all(color: Colors.black)),
                child: board[row][col] != null
                    ? Image.asset('assets/${board[row][col]}.png')
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

  Future<void> onMove(List<List<String?>> board, int row, int col) async {
    setState(() {
      String? move = board[row][col];

      if (selectedRow == null && selectedCol == null) {
        if (board[row][col] != null) {
          selectedRow = row;
          selectedCol = col;
          if (!(currentTurn == "white" &&
                  board[selectedRow!][selectedCol!]!.startsWith("white")) &&
              !(currentTurn == "black" &&
                  board[row][col]!.startsWith("black"))) {
            selectedRow = null;
            selectedCol = null;
          }
        }
      } else {
        if ((currentTurn == "white" &&
                board[selectedRow!][selectedCol!]!.startsWith("white")) ||
            (currentTurn == "black" &&
                board[selectedRow!][selectedCol!]!.startsWith("black"))) {
          if (row == selectedRow && col == selectedCol) {
            selectedRow = null;
            selectedCol = null;
            return;
          }

          if (!checkLegalMove(board, selectedRow!, selectedCol!, row, col)) {
            return;
          }
          String? target = board[selectedRow!][selectedCol!];

          board[row][col] = board[selectedRow!][selectedCol!];
          board[selectedRow!][selectedCol!] = null;
          if (isCheck(board, currentTurn)) {
            board[row][col] = move;
            board[selectedRow!][selectedCol!] = target;
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Board()));
                        },
                      )
                    ],
                  );
                });
          }
        }
        addMove(Move(
            isCapture: move != null,
            piece: Image.asset(
              "assets/${board[row][col]}.png",
              scale: 1.8,
            ),
            from:
                "${String.fromCharCode(97 + selectedCol!)}${8 - selectedRow!}",
            to: "${String.fromCharCode(97 + col)}${8 - row}"));
        selectedRow = null;
        selectedCol = null;
        currentTurn = currentTurn == "white" ? "black" : "white";
      }
    });
    if ((board[row][col] == "white_pawn" && row == 0) ||
        (board[row][col] == "black_pawn" && row == 7)) {
      showPromotionDialog(context, board[row][col]!.split("_")[0])
          .then((promotedPiece) {
        if (promotedPiece != null) {
          setState(() {
            board[row][col] = promotedPiece;
          });
        }
      });
    }
  }
}
