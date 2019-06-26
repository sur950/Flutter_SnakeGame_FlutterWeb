import 'dart:async';
import 'dart:math';
import 'package:flutter_web/material.dart';
import 'children_at_different_game_states.dart';

enum Direction { LEFT, RIGHT, UP, DOWN }
enum GameState { START, RUNNING, FAILURE }

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<Game> {
  var snakePosition;
  Point newPointPosition;
  Timer timer;
  Direction _direction = Direction.UP;
  var gameState = GameState.START;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 900,
          height: 500,
          padding: EdgeInsets.only(top: 35, bottom: 35, left: 70, right: 30),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('snake_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (tapUpDetails) {
              _handleTap(tapUpDetails);
            },
            child: _getChildBasedOnGameState(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 10.0, color: Colors.red),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "Score\n$score",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _direction = Direction.UP;
                        });
                      },
                      color: Colors.green,
                      child: Text("Up"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _direction = Direction.LEFT;
                          });
                        },
                        color: Colors.yellow,
                        child: Text("Left"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              _direction = Direction.RIGHT;
                            });
                          },
                          color: Colors.yellow,
                          child: Text("Right"),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _direction = Direction.DOWN;
                        });
                      },
                      color: Colors.green,
                      child: Text("Down"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleTap(TapUpDetails tapUpDetails) {
    switch (gameState) {
      case GameState.START:
        startToRunState();
        break;
      case GameState.RUNNING:
        break;
      case GameState.FAILURE:
        setGameState(GameState.START);
        break;
    }
  }

  void startToRunState() {
    startingSnake();
    generatenewPoint();
    _direction = Direction.UP;
    setGameState(GameState.RUNNING);
    timer = new Timer.periodic(new Duration(milliseconds: 400), onTimeTick);
  }

  void startingSnake() {
    setState(() {
      final midPoint = (320 / 20 / 2);
      snakePosition = [
        Point(midPoint, midPoint - 1),
        Point(midPoint, midPoint),
        Point(midPoint, midPoint + 1),
      ];
    });
  }

  void generatenewPoint() {
    setState(() {
      Random rng = Random();
      var min = 0;
      var max = 320 ~/ 20;
      var nextX = min + rng.nextInt(max - min);
      var nextY = min + rng.nextInt(max - min);

      var newRedPoint = Point(nextX.toDouble(), nextY.toDouble());

      if (snakePosition.contains(newRedPoint)) {
        generatenewPoint();
      } else {
        newPointPosition = newRedPoint;
      }
    });
  }

  void setGameState(GameState _gameState) {
    setState(() {
      gameState = _gameState;
    });
  }

  Widget _getChildBasedOnGameState() {
    var child;
    switch (gameState) {
      case GameState.START:
        setState(() {
          score = 0;
        });
        child = gameStartChild;
        break;

      case GameState.RUNNING:
        List<Positioned> snakePiecesWithNewPoints = List();
        snakePosition.forEach(
          (i) {
            snakePiecesWithNewPoints.add(
              Positioned(
                child: gameRunningChild,
                left: i.x * 47,
                top: i.y * 26,
              ),
            );
          },
        );
        final latestPoint = Positioned(
          child: newSnakePointInGame,
          left: newPointPosition.x * 45,
          top: newPointPosition.y * 25,
        );
        snakePiecesWithNewPoints.add(latestPoint);
        child = Stack(children: snakePiecesWithNewPoints);
        break;

      case GameState.FAILURE:
        timer.cancel();
        child = Container(
          width: 900,
          height: 500,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              "You Scored: $score\nTap to play again!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 30,
              ),
            ),
          ),
        );
        break;
    }
    return child;
  }

  void onTimeTick(Timer timer) {
    setState(() {
      snakePosition.insert(0, getLatestSnake());
      snakePosition.removeLast();
    });

    var currentHeadPos = snakePosition.first;
    if (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > 320 / 20 ||
        currentHeadPos.y > 320 / 20) {
      setGameState(GameState.FAILURE);
      return;
    }

    if (snakePosition.first.x == newPointPosition.x &&
        snakePosition.first.y == newPointPosition.y) {
      generatenewPoint();
      setState(() {
        if (score <= 10) {
          score = score + 1;
        } else if (score > 10 && score <= 25) {
          score = score + 2;
        } else {
          score = score + 3;
        }

        snakePosition.insert(0, getLatestSnake());
      });
    }
  }

  Point getLatestSnake() {
    var newHeadPos;

    switch (_direction) {
      case Direction.LEFT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;

      case Direction.RIGHT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;

      case Direction.UP:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case Direction.DOWN:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
    }

    return newHeadPos;
  }
}