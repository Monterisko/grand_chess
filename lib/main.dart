import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grand_chess/pages/HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrandChess',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
