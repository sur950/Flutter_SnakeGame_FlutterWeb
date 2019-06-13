import 'package:flutter_web/material.dart';

import 'game.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Olden Days Snake Game',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Snake Game"),
        centerTitle: true,
      ),
      backgroundColor: Colors.brown[500],
      body: Game(),
    );
  }
}
