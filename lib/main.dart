import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grand_chess/components/PGN.dart';
import 'package:grand_chess/firebase_options.dart';
import 'package:grand_chess/pages/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const pgnContent = '''
[Event "Friendly Game"]
[Site "Online"]
[Date "2025.05.06"]
[Round "1"]
[White "Player1"]
[Black "Player2"]
[Result "1-0"]

1. e4 e5
''';
  importFromPGN(pgnContent);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrandChess',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
