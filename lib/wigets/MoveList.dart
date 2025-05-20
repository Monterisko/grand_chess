import 'package:flutter/material.dart';
import 'package:grand_chess/components/Move.dart';
import 'package:grand_chess/controllers/HeightController.dart';

List<Move> moves = [];

Widget displayMoves(ScrollController controller) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });
  return ValueListenableBuilder(
    valueListenable: HeightController.heightNotifier,
    builder: (context, height, _) {
      return Container(
        height: height,
        width: 370,
        color: Color.fromRGBO(38, 36, 33, 1),
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
                          if (index * 2 < moves.length)
                            Text(
                              moves[index * 2].to,
                              style: TextStyle(color: Colors.white),
                            ),
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
                            Text(
                              moves[index * 2 + 1].to,
                              style: TextStyle(color: Colors.white),
                            ),
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
    },
  );
}

void addMove(Move move) {
  moves.add(move);
}

void setMoveList(List<Move> m) {
  moves = m;
}

void clearMoves() {
  moves.clear();
}
