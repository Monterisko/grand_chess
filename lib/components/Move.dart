import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Move.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Move(
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      figure: data['figure'] ?? '',
      color: data['color'] ?? '',
      isCapture: data['isCapture'] ?? false,
      piece: Image.asset('assets/${data['piece'] ?? 'white_pawn'}.png'),
    );
  }

  @override
  String toString() {
    return "from: $from, to: $to, piece: $piece, isCapture: $isCapture";
  }
}
