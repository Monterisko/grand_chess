import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/BoardMove.dart';
import 'package:grand_chess/wigets/bots/Bot.dart';

class Board extends StatefulWidget {
  BotSettings settings;
  Board({super.key, required this.settings});

  @override
  State<StatefulWidget> createState() {
    return BoardMove(settings: settings);
  }
}
