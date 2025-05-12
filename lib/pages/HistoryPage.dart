import 'package:flutter/material.dart';
import 'package:grand_chess/database/Database.dart';
import 'package:grand_chess/wigets/MenuBar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HistoryPageState();
  }
}

class HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 118 / constraints.maxHeight],
                colors: [
                  Color.fromRGBO(46, 42, 36, 1),
                  Color.fromRGBO(22, 21, 18, 1)
                ],
              ),
            ),
            child: Column(
              children: [
                menuBar(context),
                Table(
                  border: TableBorder.all(color: Colors.white),
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Text(
                            "ID",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            "Gracze",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            "Wynik",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: ElevatedButton(
                            onPressed: () {
                              fetchAllGames();
                            },
                            child: Text(
                              'Test',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            "Gracze",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            "Wynik",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
