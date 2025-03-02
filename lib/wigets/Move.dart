import 'package:flutter/material.dart';

class Move {
  final String figure;
  final String from;
  final String to;
  final Image piece;
  final bool isCapture;
  final String color;

  Move(
      {required this.from,
      required this.to,
      required this.piece,
      this.isCapture = false,
      this.figure = "",
      this.color = ""});

  @override
  String toString() {
    return "from: $from, to: $to, piece: $piece, isCapture: $isCapture";
  }
}
