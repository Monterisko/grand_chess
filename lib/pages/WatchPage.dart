import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grand_chess/auth/Auth.dart';
import 'package:grand_chess/components/Move.dart';
import 'package:grand_chess/components/PGN.dart';
import 'package:grand_chess/wigets/MenuBar.dart';
import 'package:grand_chess/wigets/MoveList.dart';
import 'package:grand_chess/wigets/ResizableContainer.dart';

class WatchPage extends StatefulWidget {
  final String gameId;
  const WatchPage({super.key, required this.gameId});

  @override
  _WatchPageState createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  List<List<String?>> board = List.generate(8, (_) => List.filled(8, null));
  final ScrollController controller = ScrollController();
  final FocusNode _focusNode = FocusNode();
  int currentIndex = -1;

  void initializeBoard() {
    board[7][0] = "white_rook";
    board[7][1] = "white_knight";
    board[7][2] = "white_bishop";
    board[7][3] = "white_queen";
    board[7][4] = "white_king";
    board[7][5] = "white_bishop";
    board[7][6] = "white_knight";
    board[7][7] = "white_rook";
    for (int i = 0; i < 8; i++) {
      board[6][i] = "white_pawn";
    }
    board[0][0] = "black_rook";
    board[0][1] = "black_knight";
    board[0][2] = "black_bishop";
    board[0][3] = "black_queen";
    board[0][4] = "black_king";
    board[0][5] = "black_bishop";
    board[0][6] = "black_knight";
    board[0][7] = "black_rook";
    for (int i = 0; i < 8; i++) {
      board[1][i] = "black_pawn";
    }
  }

  void nextMove() {
    if (currentIndex + 1 > moves.length - 1) return;
    Move m = moves[++currentIndex];
    List<int> fromCoords = algebraicToCoords(m.from);
    List<int> toCoords = algebraicToCoords(m.to);
    move(fromCoords[0], fromCoords[1], toCoords[0], toCoords[1]);
  }

  void previousMove() {
    if (currentIndex < 0) return;
    Move m = moves[currentIndex--];
    List<int> fromCoords = algebraicToCoords(m.from);
    List<int> toCoords = algebraicToCoords(m.to);
    move(toCoords[0], toCoords[1], fromCoords[0], fromCoords[1]);
  }

  void move(int fromRow, int fromCol, int toRow, int toCol) {
    setState(() {
      board[toRow][toCol] = board[fromRow][fromCol];
      board[fromRow][fromCol] = null;
    });
  }

  void handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        previousMove();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        nextMove();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initializeBoard();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      onKeyEvent: handleKey,
      focusNode: _focusNode,
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(getUserId())
            .collection('games')
            .doc(widget.gameId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final data = snapshot.data!.data()!;
          final List<dynamic> movesData = data['moves'] ?? [];

          final moves = movesData.map((moveMap) {
            final map = moveMap as Map<String, dynamic>;
            return Move(
              from: map['from'] ?? '',
              to: map['to'] ?? '',
              figure: map['figure'] ?? '',
              color: map['color'] ?? '',
              isCapture: map['isCapture'] ?? false,
              piece: Image.asset('assets/${map['piece'] ?? 'white_pawn'}.png',
                  scale: 1.8),
            );
          }).toList();
          setMoveList(moves);

          return Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 118 / constraints.maxHeight],
                      colors: [
                        Color.fromRGBO(46, 42, 36, 1),
                        Color.fromRGBO(22, 21, 18, 1)
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      menuBar(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
                          ResizableContainer(
                            initSize: 400,
                            minSize: 400,
                            maxSize: 800,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 8),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int toRow = index ~/ 8;
                                    int toCol = index % 8;

                                    return GestureDetector(
                                      onTap: () => {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: (toRow + toCol) % 2 == 0
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    255, 159, 86, 60),
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: board[toRow][toCol] != null
                                            ? Image.asset(
                                                'assets/${board[toRow][toCol]}.png')
                                            : null,
                                      ),
                                    );
                                  },
                                  itemCount: 64,
                                ),
                              ),
                            ),
                          ),
                          displayMoves(controller),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
