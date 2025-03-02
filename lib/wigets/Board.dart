import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/BoardMove.dart';

class Board extends StatefulWidget {
  bool isAgainstAI;
  Board({super.key, required this.isAgainstAI});

  @override
  State<StatefulWidget> createState() {
    return BoardMove(isAgainstAI: isAgainstAI);
  }
}
