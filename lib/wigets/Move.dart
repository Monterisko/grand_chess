import 'package:flutter/material.dart';

class Move {
  final String from;
  final String to;
  final Image piece;
  final bool isCapture;

  Move(
      {required this.from,
      required this.to,
      required this.piece,
      this.isCapture = false});
}
