import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Move.dart';

List<Move> moves = [];

Widget displayMoves(ScrollController controller) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });

  return SizedBox(
    height: 200,
    width: 500,
    child: ListView.builder(
      controller: controller,
      itemCount: (moves.length / 2).ceil(),
      itemBuilder: (context, index) {
        return Table(
          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (index * 2 < moves.length) moves[index * 2].piece,
                      if (index * 2 < moves.length) Text(moves[index * 2].to),
                    ],
                  ),
                ),
                TableCell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (index * 2 + 1 < moves.length)
                        moves[index * 2 + 1].piece,
                      if (index * 2 + 1 < moves.length)
                        Text(moves[index * 2 + 1].to),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}

void addMove(Move move) {
  moves.add(move);
}

void clearMoves() {
  moves.clear();
}
