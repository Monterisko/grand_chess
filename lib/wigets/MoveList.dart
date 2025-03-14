import 'package:flutter/material.dart';
import 'package:grand_chess/wigets/Move.dart';

List<Move> moves = [];

Widget displayMoves() {
  final ScrollController _controllerOne = ScrollController();
  return Container(
      margin: EdgeInsets.only(top: 40, left: 20),
      child: SizedBox(
          width: 200,
          height: 400,
          child: Row(
            children: [
              SizedBox(
                  width: 100,
                  child: Scrollbar(
                      controller: _controllerOne,
                      child: ListView.builder(
                        itemCount: moves.length,
                        controller: _controllerOne,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              children: [
                                if (index % 2 == 0) moves[index].piece,
                                if (index % 2 == 0)
                                  Text(
                                    "${moves[index].to}",
                                  ),
                              ],
                            ),
                          );
                        },
                      ))),
              SizedBox(
                  width: 100,
                  child: Scrollbar(
                      controller: _controllerOne,
                      child: ListView.builder(
                        itemCount: moves.length,
                        controller: _controllerOne,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              children: [
                                if (index % 2 != 0) moves[index].piece,
                                if (index % 2 != 0)
                                  Text(
                                    moves[index].to,
                                  ),
                              ],
                            ),
                          );
                        },
                      )))
            ],
          )));
}

void addMove(Move move) {
  moves.add(move);
}

void clearMoves() {
  moves.clear();
}
