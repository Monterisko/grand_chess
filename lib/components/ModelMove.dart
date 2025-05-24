import 'package:cloud_firestore/cloud_firestore.dart';

class ModelMove {
  final String from;
  final String to;
  final bool isCapture;
  final String color;
  final String piece;
  final Timestamp timestamp;

  ModelMove({
    required this.from,
    required this.to,
    required this.isCapture,
    required this.color,
    required this.piece,
    required this.timestamp,
  });

  factory ModelMove.fromMap(Map<String, dynamic> map) {
    return ModelMove(
      from: map['from'],
      to: map['to'],
      isCapture: map['isCapture'],
      color: map['color'],
      piece: map['piece'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'isCapture': isCapture,
      'color': color,
      'piece': piece,
      'timestamp': timestamp,
    };
  }
}
