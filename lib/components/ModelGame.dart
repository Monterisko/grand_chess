import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grand_chess/components/ModelMove.dart';

class ModelGame {
  final String id;
  final String? result;
  final String whitePlayerId;
  final String? blackPlayerId;
  final List<String> players;
  final String status;
  final String currentTurn;
  final List<ModelMove> moves;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  ModelGame({
    required this.id,
    this.result,
    required this.whitePlayerId,
    this.blackPlayerId,
    required this.players,
    required this.status,
    required this.currentTurn,
    required this.moves,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelGame.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ModelGame(
      id: doc.id,
      result: data['result'],
      whitePlayerId: data['whitePlayerId'],
      blackPlayerId: data['blackPlayerId'],
      players: List<String>.from(data['players']),
      status: data['status'],
      currentTurn: data['currentTurn'],
      moves: (data['moves'] as List<dynamic>)
          .map((m) => ModelMove.fromMap(m))
          .toList(),
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'result': result,
      'whitePlayerId': whitePlayerId,
      'blackPlayerId': blackPlayerId,
      'players': players,
      'status': status,
      'currentTurn': currentTurn,
      'moves': moves.map((m) => m.toMap()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
