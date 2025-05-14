import 'package:flutter/material.dart';
import 'package:grand_chess/components/Move.dart';
import 'package:grand_chess/wigets/Game.dart';

class PGN {
  String _eventName;
  String _siteName;
  String _date;
  String _round;
  String _whitePlayerName;
  String _blackPlayerName;
  String _result;
  String _whiteElo;
  String _blackElo;
  List<Move> _moves;
  final List<List<String?>> _board =
      List.generate(8, (_) => List.filled(8, null));

  set setEventName(String eventName) {
    _eventName = eventName;
  }

  set setSiteName(String siteName) {
    _siteName = siteName;
  }

  set setDate(String date) {
    _date = date;
  }

  set setRound(String round) {
    _round = round;
  }

  set setWhitePlayerName(String whitePlayerName) {
    _whitePlayerName = whitePlayerName;
  }

  set setBlackPlayerName(String blackPlayerName) {
    _blackPlayerName = blackPlayerName;
  }

  set setResult(String result) {
    _result = result;
  }

  set setWhiteElo(String whiteElo) {
    _whiteElo = whiteElo;
  }

  set setBlackElo(String blackElo) {
    _blackElo = blackElo;
  }

  set setMoves(List<Move> moves) {
    _moves = moves;
  }

  void initBoard() {
    _board[7][0] = "white_rook";
    _board[7][1] = "white_knight";
    _board[7][2] = "white_bishop";
    _board[7][3] = "white_queen";
    _board[7][4] = "white_king";
    _board[7][5] = "white_bishop";
    _board[7][6] = "white_knight";
    _board[7][7] = "white_rook";
    for (int i = 0; i < 8; i++) {
      _board[6][i] = "white_pawn";
    }
    _board[0][0] = "black_rook";
    _board[0][1] = "black_knight";
    _board[0][2] = "black_bishop";
    _board[0][3] = "black_queen";
    _board[0][4] = "black_king";
    _board[0][5] = "black_bishop";
    _board[0][6] = "black_knight";
    _board[0][7] = "black_rook";
    for (int i = 0; i < 8; i++) {
      _board[1][i] = "black_pawn";
    }
  }

  List<List<String?>> get getBoard => _board;
  String get getEventName => _eventName;
  String get getSiteName => _siteName;
  String get getDate => _date;
  String get getRound => _round;
  String get getWhitePlayerName => _whitePlayerName;
  String get getBlackPlayerName => _blackPlayerName;
  String get getResult => _result;
  String get getWhiteElo => _whiteElo;
  String get getBlackElo => _blackElo;
  String get getMoves => _moves.map<String>((move) => move.to).join(" ");

  PGN(
      {moves = const <Move>[],
      eventName = "",
      siteName = "",
      date = "",
      round = "",
      whitePlayerName = "",
      blackPlayerName = "",
      result = "",
      whiteElo = "",
      blackElo = ""})
      : _moves = moves,
        _eventName = eventName,
        _siteName = siteName,
        _date = date,
        _round = round,
        _whitePlayerName = whitePlayerName,
        _blackPlayerName = blackPlayerName,
        _result = result,
        _whiteElo = whiteElo,
        _blackElo = blackElo;
}

PGN pgnObj = PGN();

PGN importFromPGN(String pgn) {
  String turn = "";
  List<Move> moves = [];
  pgnObj.initBoard();
  List<String> lines = pgn.split('\n');
  for (String line in lines) {
    if (line.isEmpty) continue;
    if (line.contains("Event")) {
      pgnObj.setEventName = line.split("\"")[1];
    } else if (line.contains("Site")) {
      pgnObj.setEventName = line.split("\"")[1];
    } else if (line.contains("Date")) {
      pgnObj.setEventName = line.split("\"")[1];
    } else if (line.contains("Round")) {
      pgnObj.setEventName = line.split("\"")[1];
    } else if (line.contains("White")) {
      pgnObj.setEventName = line.split("\"")[1];
    } else if (line.contains("Black")) {
      pgnObj.setEventName = line.split("\"")[1];
    } else if (line.contains("Result")) {
      pgnObj.setEventName = line.split("\"")[1];
    } else if (line.contains("WhiteElo")) {
      pgnObj.setEventName = line.split("\"")[1];
    } else if (line.contains("BlackElo")) {
      pgnObj.setEventName = line.split("\"")[1];
    } else if (line.contains(RegExp(r'\d+\.\s*'))) {
      List<String> moveList =
          line.replaceAll(RegExp(r'\d+\.\s*'), '').split(" ");
      for (int i = 0; i < moveList.length; i++) {
        if (i % 2 == 0) {
          turn = "white";
        } else {
          turn = "black";
        }
        moves.add(
          Move(
            from: getPieceForPgnMove(moveList[i], turn)!,
            to: moveList[i],
            piece: Image.asset(
              '${turn}_${pieceTypeFromSymbol(moveList[i][0])}',
            ),
          ),
        );
        var from = algebraicToCoords(getPieceForPgnMove(moveList[i], turn)!);
        var to = algebraicToCoords(moveList[i]);
        move(from[0], from[1], to[0], to[1]);
      }
    }
  }

  return pgnObj;
}

void move(int fromRow, int fromCol, int toRow, int toCol) {
  pgnObj._board[toRow][toCol] = pgnObj._board[fromRow][fromCol];
  pgnObj._board[fromRow][fromCol] = null;
}

String exportToPGN(PGN pgn) {
  String pgnString = "[Event \"${pgn.getEventName}\"]\n";
  pgnString += "[Site \"${pgn.getSiteName}\"\n]";
  pgnString += "[Date \"${pgn.getDate}\"\n]";
  pgnString += "[White \"${pgn.getWhitePlayerName}\"\n]";
  pgnString += "[Black \"${pgn.getBlackPlayerName}\"\n]";
  pgnString += "[Result \"${pgn.getResult}\"\n]";
  pgnString += "\n";
  for (var i = 0; i < pgn.getMoves.length; i++) {
    final move_number = (i ~/ 2) + 1;
    final whiteMove = pgn.getMoves[i];
    final blackMove = i + 1 < pgn.getMoves.length ? pgn.getMoves[i + 1] : '';
    pgnString += '$move_number. $whiteMove $blackMove ';
  }
  return pgnString;
}

List<int> algebraicToCoords(String square) {
  final file = square[0].codeUnitAt(0) - 'a'.codeUnitAt(0);
  final rank = 8 - int.parse(square[1]);
  return [rank, file];
}

String coordsToAlgebraic(int row, int col) {
  final file = String.fromCharCode('a'.codeUnitAt(0) + col);
  final rank = (8 - row).toString();
  return '$file$rank';
}

bool matchesSpecificFileAndRank(
    int row, int col, String? specificFile, String? specificRank) {
  if (specificFile != null &&
      col != specificFile.codeUnitAt(0) - 'a'.codeUnitAt(0)) {
    return false;
  }
  if (specificRank != null && row != 8 - int.parse(specificRank)) {
    return false;
  }
  return true;
}

String pieceTypeFromSymbol(String symbol) {
  switch (symbol) {
    case 'R':
      return 'rook';
    case 'N':
      return 'knight';
    case 'B':
      return 'bishop';
    case 'Q':
      return 'queen';
    case 'K':
      return 'king';
    default:
      return 'pawn';
  }
}

String? handleCastling(String pgnMove, String color) {
  final row = color == "white" ? 7 : 0;
  if (pgnMove == "O-O") {
    if (pgnObj._board[row][4] == "${color}_king" &&
        pgnObj._board[row][7] == "${color}_rook") {
      return "e${8 - row}";
    }
  } else if (pgnMove == "O-O-O") {
    if (pgnObj._board[row][4] == "${color}_king" &&
        pgnObj._board[row][0] == "${color}_rook") {
      return "e${8 - row}";
    }
  }
  return null;
}
