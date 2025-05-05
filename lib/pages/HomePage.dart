import 'package:flutter/material.dart';
import '../wigets/MenuBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<String?>> board = List.generate(8, (_) => List.filled(8, null));
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
              ],
            ),
          );
        },
      ),
    );
  }
}
