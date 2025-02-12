void checkLegalMove(List<List<String?>> board, int selectedRow, int selectedCol,
    int row, int col) {
  if (board[selectedRow][selectedCol] == "white_pawn") {
    if (selectedRow == 6) {
      if (row == selectedRow - 1 && col == selectedCol) {
        if (board[row][col] == null) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
        }
      } else if (row == selectedRow - 2 && col == selectedCol) {
        if (board[row][col] == null && board[row + 1][col] == null) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
        }
      } else if (row == selectedRow - 1 &&
          (col == selectedCol + 1 || col == selectedCol - 1)) {
        if (board[row][col] != null && !board[row][col]!.startsWith("white")) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
        }
      }
    } else {
      if (row == selectedRow - 1 && col == selectedCol) {
        if (board[row][col] == null) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
        }
      } else if (row == selectedRow - 1 &&
          (col == selectedCol + 1 || col == selectedCol - 1)) {
        if (board[row][col] != null && !board[row][col]!.startsWith("white")) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
        }
      }
    }
  }
  if (board[selectedRow][selectedCol] == "black_pawn") {
    if (selectedRow == 1) {
      if (row == selectedRow + 1 && col == selectedCol) {
        if (board[row][col] == null) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
        }
      } else if (row == selectedRow + 2 && col == selectedCol) {
        if (board[row][col] == null && board[row - 1][col] == null) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
        }
      } else if (row == selectedRow + 1 &&
          (col == selectedCol + 1 || col == selectedCol - 1)) {
        if (board[row][col] != null && !board[row][col]!.startsWith("black")) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
        }
      }
    } else {
      if (row == selectedRow + 1 && col == selectedCol) {
        if (board[row][col] == null) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
        }
      } else if (row == selectedRow + 1 &&
          (col == selectedCol + 1 || col == selectedCol - 1)) {
        if (board[row][col] != null && !board[row][col]!.startsWith("black")) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
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
          print(
              "board[rowDup][colDup]: ${board[rowDup][colDup]}, rowdup: $rowDup, coldup: $colDup");
          return;
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
      print("flag: $flag");
      if (flag) {
        if (board[row][col] == null ||
            (board[selectedRow][selectedCol]!.startsWith("white")
                ? !board[row][col]!.startsWith("white")
                : !board[row][col]!.startsWith("black"))) {
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
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
        board[row][col] = board[selectedRow][selectedCol];
        board[selectedRow][selectedCol] = null;
      }
    } else if ((row == selectedRow + 1 || row == selectedRow - 1) &&
        (col == selectedCol + 2 || col == selectedCol - 2)) {
      if (board[row][col] == null ||
          (board[selectedRow][selectedCol]!.startsWith("white")
              ? !board[row][col]!.startsWith("white")
              : !board[row][col]!.startsWith("black"))) {
        board[row][col] = board[selectedRow][selectedCol];
        board[selectedRow][selectedCol] = null;
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
          return;
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
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
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
          return;
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
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
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
          return;
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
          board[row][col] = board[selectedRow][selectedCol];
          board[selectedRow][selectedCol] = null;
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
        board[row][col] = board[selectedRow][selectedCol];
        board[selectedRow][selectedCol] = null;
      }
    }
  }
  if (board[selectedRow][selectedCol] == "white_king" &&
      selectedRow == 7 &&
      selectedCol == 4 &&
      row == 7 &&
      col == 6) {
    board[7][6] = board[7][4];
    board[7][4] = null;
    board[7][5] = board[7][7];
    board[7][7] = null;
  }
  if (board[selectedRow][selectedCol] == "black_king" &&
      selectedRow == 0 &&
      selectedCol == 4 &&
      row == 0 &&
      col == 6) {
    board[0][6] = board[0][4];
    board[0][4] = null;
    board[0][5] = board[0][7];
    board[0][7] = null;
  }
  if (board[selectedRow][selectedCol] == "white_king" &&
      selectedRow == 7 &&
      selectedCol == 4 &&
      row == 7 &&
      col == 2) {
    board[7][2] = board[7][4];
    board[7][4] = null;
    board[7][3] = board[7][0];
    board[7][0] = null;
  }
  if (board[selectedRow][selectedCol] == "black_king" &&
      selectedRow == 0 &&
      selectedCol == 4 &&
      row == 0 &&
      col == 2) {
    board[0][2] = board[0][4];
    board[0][4] = null;
    board[0][3] = board[0][0];
    board[0][0] = null;
  }
}
