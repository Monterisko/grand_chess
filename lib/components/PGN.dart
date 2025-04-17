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
  List<List<String?>> _board = List.generate(8, (_) => List.filled(8, null));

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
      print(line.replaceAll(RegExp(r'\d+\.\s*'), ''));
      List<String> moveList =
          line.replaceAll(RegExp(r'\d+\.\s*'), '').split(" ");
      for (int i = 0; i < moveList.length; i++) {
        if (i % 2 == 0) {
          turn = "white";
          // if (checkLegalMovePiece(
          //     pgnObj._board,
          //     "",
          //     turn,
          //     convertCharacterToNumber(moveList[i]),
          //     int.parse(moveList[i][1]))) {}
          // for (var j = 0; j < 8; j++) {
          //   for (var k = 0; k < 8; k++) {
          //     print(pgnObj._board[j][k]);
          //   }
          //   print('\n');
          // }
        } else {
          turn = "black";
        }
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
  return pgnString;
}

int convertCharacterToNumber(String s) {
  return s.codeUnitAt(0) - 97;
}
