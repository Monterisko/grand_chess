import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/BoardMove.dart';
import 'package:grand_chess/wigets/bots/Bot.dart';

@immutable
class Board extends StatefulWidget {
  final GameSettings settings;
  const Board({super.key, required this.settings});

  @override
  State<StatefulWidget> createState() {
    return BoardMove(settings: settings);
  }
}
