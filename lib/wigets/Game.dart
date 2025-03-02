import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/BoardMove.dart';
import 'package:grand_chess/wigets/Move.dart';

bool checkLegalMove(List<List<String?>> board, int selectedRow, int selectedCol,
    int row, int col) {
  if (board[selectedRow][selectedCol] == "white_pawn") {
    if (selectedRow == 6) {
      if (row == selectedRow - 1 && col == selectedCol) {
        if (board[row][col] == null) {
          return true;
        }
      } else if (row == selectedRow - 2 && col == selectedCol) {
        if (board[row][col] == null && board[row + 1][col] == null) {
          return true;
        }
      } else if (row == selectedRow - 1 &&
          (col == selectedCol + 1 || col == selectedCol - 1)) {
        if (board[row][col] != null && !board[row][col]!.startsWith("white")) {
          return true;
        }
      }
    } else {
      if (row == selectedRow - 1 && col == selectedCol) {
        if (board[row][col] == null) {
          return true;
        }
      } else if (row == selectedRow - 1 &&
          (col == selectedCol + 1 || col == selectedCol - 1)) {
        if (board[row][col] != null && !board[row][col]!.startsWith("white")) {
          return true;
        }
      }
    }
  }
  if (board[selectedRow][selectedCol] == "black_pawn") {
    if (selectedRow == 1) {
      if (row == selectedRow + 1 && col == selectedCol) {
        if (board[row][col] == null) {
          return true;
        }
      } else if (row == selectedRow + 2 && col == selectedCol) {
        if (board[row][col] == null && board[row - 1][col] == null) {
          return true;
        }
      } else if (row == selectedRow + 1 &&
          (col == selectedCol + 1 || col == selectedCol - 1)) {
        if (board[row][col] != null && !board[row][col]!.startsWith("black")) {
          return true;
        }
      }
    } else {
      if (row == selectedRow + 1 && col == selectedCol) {
        if (board[row][col] == null) {
          return true;
        }
      } else if (row == selectedRow + 1 &&
          (col == selectedCol + 1 || col == selectedCol - 1)) {
        if (board[row][col] != null && !board[row][col]!.startsWith("black")) {
          return true;
        }
      }
    }
  }
  if (board[selectedRow][selectedCol] == "white_rook" ||
      board[selectedRow][selectedCol] == "black_rook") {
    int rowStep = (selectedRow > row)
        ? 1
        : (selectedRow < row)
            ? -1
            : 0;
    int colStep = (selectedCol > col)
        ? 1
        : (selectedCol < col)
            ? -1
            : 0;

    bool flag = true;
    int rowDup = row + rowStep;
    int colDup = col + colStep;
    if (row == selectedRow || col == selectedCol) {
      while (rowDup != selectedRow || colDup != selectedCol) {
        if (board[rowDup][colDup] != null) {
          flag = false;
          return false;
        }
        if (rowDup > selectedRow) {
          rowDup--;
        } else if (rowDup < selectedRow) {
          rowDup++;
        } else if (colDup > selectedCol) {
          colDup--;
        } else if (colDup < selectedCol) {
          colDup++;
        }
      }
      if (flag) {
        if (board[row][col] == null ||
            (board[selectedRow][selectedCol]!.startsWith("white")
                ? !board[row][col]!.startsWith("white")
                : !board[row][col]!.startsWith("black"))) {
          return true;
        }
      }
    }
  }
  if (board[selectedRow][selectedCol] == "white_knight" ||
      board[selectedRow][selectedCol] == "black_knight") {
    if ((row == selectedRow + 2 || row == selectedRow - 2) &&
        (col == selectedCol + 1 || col == selectedCol - 1)) {
      if (board[row][col] == null ||
          (board[selectedRow][selectedCol]!.startsWith("white")
              ? !board[row][col]!.startsWith("white")
              : !board[row][col]!.startsWith("black"))) {
        return true;
      }
    } else if ((row == selectedRow + 1 || row == selectedRow - 1) &&
        (col == selectedCol + 2 || col == selectedCol - 2)) {
      if (board[row][col] == null ||
          (board[selectedRow][selectedCol]!.startsWith("white")
              ? !board[row][col]!.startsWith("white")
              : !board[row][col]!.startsWith("black"))) {
        return true;
      }
    }
  }
  if (board[selectedRow][selectedCol] == "white_bishop" ||
      board[selectedRow][selectedCol] == "black_bishop") {
    int rowStep = (selectedRow > row)
        ? 1
        : (selectedRow < row)
            ? -1
            : 0;
    int colStep = (selectedCol > col)
        ? 1
        : (selectedCol < col)
            ? -1
            : 0;

    bool flag = true;
    int rowDup = row + rowStep;
    int colDup = col + colStep;
    if (row - selectedRow == col - selectedCol ||
        row - selectedRow == selectedCol - col) {
      while (rowDup != selectedRow || colDup != selectedCol) {
        if (board[rowDup][colDup] != null) {
          flag = false;
          return false;
        }
        if (rowDup > selectedRow && colDup > selectedCol) {
          rowDup--;
          colDup--;
        } else if (rowDup > selectedRow && colDup < selectedCol) {
          rowDup--;
          colDup++;
        } else if (rowDup < selectedRow && colDup > selectedCol) {
          rowDup++;
          colDup--;
        } else if (rowDup < selectedRow && colDup < selectedCol) {
          rowDup++;
          colDup++;
        }
      }
      if (flag) {
        if (board[row][col] == null ||
            (board[selectedRow][selectedCol]!.startsWith("white")
                ? !board[row][col]!.startsWith("white")
                : !board[row][col]!.startsWith("black"))) {
          return true;
        }
      }
    }
  }
  if (board[selectedRow][selectedCol] == "white_queen" ||
      board[selectedRow][selectedCol] == "black_queen") {
    int rowStep = (selectedRow > row)
        ? 1
        : (selectedRow < row)
            ? -1
            : 0;
    int colStep = (selectedCol > col)
        ? 1
        : (selectedCol < col)
            ? -1
            : 0;

    bool flag = true;
    int rowDup = row + rowStep;
    int colDup = col + colStep;
    if (row == selectedRow || col == selectedCol) {
      while (rowDup != selectedRow || colDup != selectedCol) {
        if (board[rowDup][colDup] != null) {
          flag = false;
          return false;
        }
        if (rowDup > selectedRow) {
          rowDup--;
        } else if (rowDup < selectedRow) {
          rowDup++;
        } else if (colDup > selectedCol) {
          colDup--;
        } else if (colDup < selectedCol) {
          colDup++;
        }
      }
      if (flag) {
        if (board[row][col] == null ||
            (board[selectedRow][selectedCol]!.startsWith("white")
                ? !board[row][col]!.startsWith("white")
                : !board[row][col]!.startsWith("black"))) {
          return true;
        }
      }
    }
    flag = true;
    rowDup = row + rowStep;
    colDup = col + colStep;
    if (row - selectedRow == col - selectedCol ||
        row - selectedRow == selectedCol - col) {
      while (rowDup != selectedRow || colDup != selectedCol) {
        if (board[rowDup][colDup] != null) {
          flag = false;
          return false;
        }
        if (rowDup > selectedRow && colDup > selectedCol) {
          rowDup--;
          colDup--;
        } else if (rowDup > selectedRow && colDup < selectedCol) {
          rowDup--;
          colDup++;
        } else if (rowDup < selectedRow && colDup > selectedCol) {
          rowDup++;
          colDup--;
        } else if (rowDup < selectedRow && colDup < selectedCol) {
          rowDup++;
          colDup++;
        }
      }
      if (flag) {
        if (board[row][col] == null ||
            (board[selectedRow][selectedCol]!.startsWith("white")
                ? !board[row][col]!.startsWith("white")
                : !board[row][col]!.startsWith("black"))) {
          return true;
        }
      }
    }
  }
  if (board[selectedRow][selectedCol] == "white_king" ||
      board[selectedRow][selectedCol] == "black_king") {
    if ((row == selectedRow + 1 ||
            row == selectedRow - 1 ||
            row == selectedRow) &&
        (col == selectedCol + 1 ||
            col == selectedCol - 1 ||
            col == selectedCol)) {
      if (board[row][col] == null ||
          (board[selectedRow][selectedCol]!.startsWith("white")
              ? !board[row][col]!.startsWith("white")
              : !board[row][col]!.startsWith("black"))) {
        return true;
      }
    }
  }
  if (BoardMove.castleW || BoardMove.castleB) {
    if (board[selectedRow][selectedCol] == "white_king" &&
        selectedRow == 7 &&
        selectedCol == 4 &&
        row == 7 &&
        col > 4) {
      for (int i = 5; i < 7; i++) {
        if (board[7][i] != null) {
          return false;
        }
      }
      board[7][5] = "white_rook";
      board[7][7] = null;
      BoardMove.castleW = false;
      return true;
    }
    if (board[selectedRow][selectedCol] == "black_king" &&
        selectedRow == 0 &&
        selectedCol == 4 &&
        row == 0 &&
        col == 6) {
      for (int i = 5; i < 7; i++) {
        if (board[0][i] != null) {
          return false;
        }
      }
      board[0][5] = "black_rook";
      board[0][7] = null;
      BoardMove.castleB = false;
      return true;
    }
    if (board[selectedRow][selectedCol] == "white_king" &&
        selectedRow == 7 &&
        selectedCol == 4 &&
        row == 7 &&
        col == 2) {
      for (int i = 1; i < 4; i++) {
        if (board[7][i] != null) {
          return false;
        }
      }
      board[7][3] = "white_rook";
      board[7][0] = null;
      BoardMove.castleW = false;
      return true;
    }
    if (board[selectedRow][selectedCol] == "black_king" &&
        selectedRow == 0 &&
        selectedCol == 4 &&
        row == 0 &&
        col == 2) {
      for (int i = 1; i < 4; i++) {
        if (board[0][i] != null) {
          return false;
        }
      }
      board[0][3] = "black_rook";
      board[0][0] = null;
      BoardMove.castleB = false;
      return true;
    }
  }
  return false;
}

bool checkEnPassant(List<List<String?>> board, int selectedRow, int selectedCol,
    int row, int col, Move previousMove) {
  print(
      "selectedRow: $selectedRow, selectedCol: $selectedCol, row: $row, col: $col, figure: ${previousMove.figure}, previousMove: ${previousMove.toString()}");

  if (previousMove.color == "white" ? selectedRow != 4 : selectedRow != 3) {
    return false;
  }

  if (previousMove.color == "black"
      ? !(previousMove.figure == "black_pawn" &&
          previousMove.from[1] == "7" &&
          previousMove.to[1] == "5")
      : !(previousMove.figure == "white_pawn" &&
          previousMove.from[1] == "2" &&
          previousMove.to[1] == "4")) {
    return false;
  }

  bool isAdjacentCol =
      (previousMove.to.codeUnitAt(0) - 97 - selectedCol).abs() == 1;
  bool isCorrectRow = (previousMove.to[1] == "5" || previousMove.to[1] == "4");
  print("isAdjacentCol: $isAdjacentCol, isCorrectRow: $isCorrectRow");
  return isCorrectRow && isAdjacentCol;
}

bool isCheck(List<List<String?>> board, String color) {
  int kingRow = -1;
  int kingCol = -1;

  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (board[i][j] == "${color}_king") {
        kingRow = i;
        kingCol = j;
        break;
      }
    }
  }

  String opponentColor = (color == "white") ? "black" : "white";

  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      String? piece = board[r][c];

      if (piece != null && piece.startsWith(opponentColor)) {
        if (checkLegalMove(board, r, c, kingRow, kingCol)) {
          return true;
        }
      }
    }
  }
  return false;
}

bool isCheckMate(List<List<String?>> board, String color) {
  if (!isCheck(board, color)) {
    return false;
  }

  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      String? piece = board[r][c];

      if (piece != null && piece.startsWith(color)) {
        for (int newR = 0; newR < 8; newR++) {
          for (int newC = 0; newC < 8; newC++) {
            if (checkLegalMove(board, r, c, newR, newC)) {
              List<List<String?>> tempBoard =
                  List.generate(8, (i) => List<String?>.from(board[i]));

              tempBoard[newR][newC] = piece;
              tempBoard[r][c] = null;

              if (!isCheck(tempBoard, color)) {
                return false;
              }
            }
          }
        }
      }
    }
  }

  return true;
}

Future<String?> showPromotionDialog(BuildContext context, String color) async {
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Promocja", textAlign: TextAlign.center),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset("assets/${color}_queen.png"),
                  iconSize: 30,
                  onPressed: () => Navigator.pop(context, "${color}_queen"),
                ),
                IconButton(
                  icon: Image.asset("assets/${color}_rook.png"),
                  iconSize: 30,
                  onPressed: () => Navigator.pop(context, "${color}_rook"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset("assets/${color}_bishop.png"),
                  iconSize: 30,
                  onPressed: () => Navigator.pop(context, "${color}_bishop"),
                ),
                IconButton(
                  icon: Image.asset("assets/${color}_knight.png"),
                  iconSize: 30,
                  onPressed: () => Navigator.pop(context, "${color}_knight"),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
