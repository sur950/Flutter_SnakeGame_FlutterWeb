import 'package:flutter_web/material.dart';

final Widget gameStartChild = Container(
  width: 900,
  height: 500,
  padding: const EdgeInsets.all(32),
  child: Center(
    child: Text(
      "Tap to start the Game!\nDo not Touch Walls:)",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.blue,fontSize: 30),
    ),
  ),
);

final Widget gameRunningChild = Container(
  width: 47,
  height: 26,
  decoration: new BoxDecoration(
    color: const Color(0xFFFF0000),
    shape: BoxShape.circle,
  ),
);

final Widget newSnakePointInGame = Container(
  width: 24,
  height: 24,
  decoration: new BoxDecoration(
    color: const Color(0xFF0080FF),
    shape: BoxShape.circle,
  ),
);

//class which gives the snake HEAD
class Point {
  double x;
  double y;

  Point(double x, double y) {
    this.x = x;
    this.y = y;
  }
}
