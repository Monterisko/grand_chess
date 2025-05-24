import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grand_chess/database/Database.dart';
import 'package:grand_chess/pages/WatchPage.dart';
import 'package:grand_chess/wigets/MenuBar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HistoryPageState();
  }
}

class HistoryPageState extends State<HistoryPage> {
  late final StreamSubscription _gamesSubscription;
  List<Map<String, dynamic>> allGames = [];
  List<String> whiteNames = [];
  List<String> blackNames = [];

  @override
  void initState() {
    super.initState();
    listenToGames();
  }

  void listenToGames() {
    _gamesSubscription = streamAllGames().listen((games) async {
      List<String> wNames = [];
      List<String> bNames = [];

      for (var game in games) {
        final type = game['gameType'];
        if (type == "online") {
          final whiteName =
              await getUsernameFromDatabase(game['whitePlayerId']);
          final blackName =
              await getUsernameFromDatabase(game['blackPlayerId']);
          wNames.add(whiteName ?? "Bot");
          bNames.add(blackName ?? "Bot");
        } else if (type == "local") {
          wNames.add("Gracz 1");
          bNames.add("Gracz 2");
        } else {
          final whiteName =
              await getUsernameFromDatabase(game['whitePlayerId']);
          wNames.add(whiteName ?? "Ty");
          bNames.add("Bot ($type)");
        }
      }

      setState(() {
        allGames = games;
        whiteNames = wNames;
        blackNames = bNames;
      });
    });
  }

  @override
  void dispose() {
    _gamesSubscription.cancel();
    super.dispose();
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
                        TableRow(
                          children: [
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
                                    whiteNames.length > i ? whiteNames[i] : "-",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    blackNames.length > i ? blackNames[i] : "-",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(
                                  allGames[i]['result'] ?? "W trakcie",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            TableCell(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WatchPage(
                                        gameId: allGames[i]['id'],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Obejrzyj",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
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
