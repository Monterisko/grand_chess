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
  List<Map<String, dynamic>> allGames = [];

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    final games = await fetchAllGames();
    setState(() {
      allGames = games;
    });
  }

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
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Table(
                    border: TableBorder.all(color: Colors.white),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: FixedColumnWidth(50),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth()
                    },
                    children: [
                      TableRow(children: [
                        TableCell(
                          child: Center(
                            child: Text(
                              "ID",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              "Gracze",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              "Wynik partii",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(child: Container()),
                      ]),
                      for (int i = 0; i < allGames.length; i++)
                        TableRow(children: [
                          TableCell(
                            child: Center(
                              child: Text(
                                "${i + 1}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Column(
                              children: [
                                Text(
                                  "-",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "-",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                allGames[i]['gameResult'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          TableCell(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Obejrzyj",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ])
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
