import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Board.dart';
import 'package:grand_chess/wigets/MenuBar.dart';
import 'package:grand_chess/wigets/Pieces.dart';

class BoardMove extends State<Board> {
  List<List<String?>> board = List.generate(8, (_) => List.filled(8, null));
  int? selectedRow;
  int? selectedCol;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(children: [menuBar(context), createBoard()]),
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

  void onMove(List<List<String?>> board, int row, int col) {
    setState(() {
      if (selectedRow == null && selectedCol == null) {
        if (board[row][col] != null) {
          selectedRow = row;
          selectedCol = col;
        }
      } else {
        checkLegalMove(board, selectedRow!, selectedCol!, row, col);
        selectedRow = null;
        selectedCol = null;
      }
    });
  }
}
