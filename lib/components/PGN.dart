import 'package:flutter/material.dart';
import 'package:grand_chess/components/Move.dart';

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
  List<Move>
      _moves; // Refers to Move from 'package:grand_chess/components/Move.dart'

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

  String get getEventName => _eventName;
  String get getSiteName => _siteName;
  String get getDate => _date;
  String get getRound => _round;
  String get getWhitePlayerName => _whitePlayerName;
  String get getBlackPlayerName => _blackPlayerName;
  String get getResult => _result;
  String get getWhiteElo => _whiteElo;
  String get getBlackElo => _blackElo;
  String get getMoves => _moves.map((move) => move.to).join(" ");

  PGN(
      {moves = const [],
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

PGN importFromPng(String pgn) {
  List<Move> moves = [];
  PGN pgnObj = PGN();
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
    } else if (line.contains("1.")) {
      List<String> moveList = line.split(" ");
      for (int i = 0; i < moveList.length; i++) {
        if (moveList[i].contains(".")) {
          continue;
        } else {
          if (moveList[i].contains("N")) {
            if (i % 2 == 0) {
              moves.add(Move(
                  from: "",
                  to: moveList[i],
                  piece: Image.asset(
                    "assets/black_knight.png",
                  )));
            } else {
              moves.add(Move(
                  from: "",
                  to: moveList[i],
                  piece: Image.asset(
                    "assets/white_knight.png",
                  )));
            }
          } else if (moveList[i].contains("B")) {
            if (i % 2 == 0) {
              moves.add(Move(
                  from: "",
                  to: moveList[i],
                  piece: Image.asset(
                    "assets/black_bishop.png",
                  )));
            } else {
              moves.add(Move(
                  from: "",
                  to: moveList[i],
                  piece: Image.asset(
                    "assets/white_bishop.png",
                  )));
            }
          } else if (moveList[i].contains("R")) {
            if (i % 2 == 0) {
              moves.add(Move(
                  from: "",
                  to: moveList[i],
                  piece: Image.asset(
                    "assets/black_rook.png",
                  )));
            } else {
              moves.add(Move(
                  from: "",
                  to: moveList[i],
                  piece: Image.asset(
                    "assets/white_rook.png",
                  )));
            }
          } else if (moveList[i].contains("Q")) {
            if (i % 2 == 0) {
              moves.add(Move(
                  from: "",
                  to: moveList[i],
                  piece: Image.asset(
                    "assets/black_queen.png",
                  )));
            } else {
              moves.add(Move(
                  from: "",
                  to: moveList[i],
                  piece: Image.asset(
                    "assets/white_queen.png",
                  )));
            }
          } else if (moveList[i].contains("K")) {
            if (i % 2 == 0) {
              moves.add(Move(
                  from: "",
                  to: moveList[i],
                  piece: Image.asset(
                    "assets/black_king.png",
                  )));
            } else {
              moves.add(Move(
                  from: "",
                  to: moveList[i],
                  piece: Image.asset(
                    "assets/white_king.png",
                  )));
            }
          } else if (moveList[i].contains("O-O")) {
            moves.add(Move(from: "", to: "", piece: Image.asset("")));
          }
        }
      }
    }
  }

  return pgnObj;
}

String exportToPGN(PGN pgn) {
  String pgnString = "[Event \"${pgn.getEventName}\"]\n";
  pgnString += "[Site \"${pgn.getSiteName}\"\n]";
  pgnString += "[Date \"${pgn.getDate}\"\n]";
  pgnString += "[White \"${pgn.getWhitePlayerName}\"\n]";
  pgnString += "[Black \"${pgn.getBlackPlayerName}\"\n]";
  pgnString += "[Result \"${pgn.getResult}\"\n]";
  return pgnString;
  ;
}
