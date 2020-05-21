import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

// #########################################################################
// ##### Start:main.dart#####
// import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterRoute(),
    );
  }
}
// ##### Finish:main.dart#####
// #########################################################################

// #########################################################################
// ##### Start:CounterRoute.dart#####
//import 'package:flutter/material.dart';
class CounterRoute extends StatelessWidget {
  const CounterRoute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FittedBox(
          child: BattleTimer(
            name: 'BattleTimer1',
          ),
        ),
      ),
    );
  }
}
// ##### Finish:CounterRoute.dart#####
// #########################################################################

// #########################################################################
// ##### Start:battle_timer.dart#####
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:math';
// import 'dart:ui';
// import 'package:my_painter.dart';//self made
class BattleTimer extends StatefulWidget {
  final String name;

  const BattleTimer({
    @required this.name,
  }) : assert(name != null);

  @override
  _BattleTimerState createState() => _BattleTimerState();
}

class _BattleTimerState extends State<BattleTimer>
    with TickerProviderStateMixin {
  // Setting Time(sec)
  int _startDefault = 3;
  int _start;

  // Setting Player data
  int _missPlayer1, _missPlayer2;
  var _colorBar = <Color>[
    Colors.redAccent,
    Colors.blueAccent,
  ];
  int _colorPlayerNumber = 0;

  // Setting Timer
  double percentage = 0.0;
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;
  Timer _timer;
  double _interval = 0.0;
  String _time = '';

  // Setting tool
  bool _isStarted = false;
  bool _isStopped = false;

  @override
  void initState() {
    super.initState();
    _initTimer();
    _missPlayer1 = 0;
    _missPlayer2 = 0;
  }

  void _initTimer() {
    _start = _startDefault;
    setState(() {
      percentage = 0.0;
      newPercentage = 0.0;
      _interval = 100 / _start;
      _onTimer(_start);
    });
    percentageAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() {
            setState(() {
              percentage = lerpDouble(percentage, newPercentage,
                  percentageAnimationController.value);
            });
          });
  }

  void _onTimer(int timer) {
    if (timer > 60) {
      _time = (timer ~/ 60).toString() + "M" + (timer % 60).toString() + "S";
    } else {
      _time = timer.toString() + "S";
    }
    if (!_isStarted) {
      _time = _time + "\nPUSH";
    }
  }

  void _startTimer() {
    if (!_isStarted) {
      const oneSec = const Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (!_isStopped) {
              if (_start < 1) {
                timer.cancel();
                //add for Timer = 0
                _initTimer();
                _isStarted = false;
                _startTimer();
                if (_colorPlayerNumber < 1) {
                  _colorPlayerNumber += 1;
                  _missPlayer1 += 1;
                } else {
                  _colorPlayerNumber = 0;
                  _missPlayer2 += 1;
                }
              } else {
                _start = _start - 1;
                _onTimer(_start);
                percentage = newPercentage;
                newPercentage += _interval;
                if (newPercentage > 100.0) {
                  percentage = 0.0;
                  newPercentage = 0.0;
                }
                percentageAnimationController.forward(from: 0.0);
              }
            }
          },
        ),
      );
    }
    _isStarted = true;
  }

  void _changePlayer() {
    _initTimer();
    _startTimer();
    if (_colorPlayerNumber < 1) {
      _colorPlayerNumber += 1;
    } else {
      _colorPlayerNumber = 0;
    }
  }

  void _incrementTimer_1S() {
    setState(() {
      _startDefault += 1;
      _initTimer();
    });
  }

  void _decrementTimer_1S() {
    setState(() {
      _startDefault -= 1;
      _initTimer();
    });
  }

  void _resetTimer() {
    setState(() {
      _timer.cancel();
      _isStarted = false;
      _missPlayer1 = 0;
      _missPlayer2 = 0;
      _initTimer();
      _colorPlayerNumber = 0;
    });
  }

  void _stopTimer() {
    setState(() {
      _isStopped = !_isStopped;
    });
  }

  @override
  Widget build(BuildContext context) {
    int _turnPlayer = _colorPlayerNumber + 1;
    return Center(
      child: FittedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Player$_turnPlayer",
              style: TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 40.0),
            Container(
              height: 280.0,
              width: 280.0,
              child: CustomPaint(
                foregroundPainter: MyPainter(
                    lineColor: _colorBar[_colorPlayerNumber],
                    completeColor: Colors.grey,
                    completePercent: percentage,
                    width: 65.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.white70,
                    textColor: Colors.black,
                    splashColor: Colors.blueAccent,
                    shape: CircleBorder(),
                    child: Text(
                      "$_time",
                      style: TextStyle(
                        fontSize: 65.0,
                        fontFamily: 'IBMPlexMono',
                      ),
                    ),
                    onPressed: () =>
                        _isStarted ? _changePlayer() : _startTimer(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("-1S"),
                  onPressed: _decrementTimer_1S,
                ),
                RaisedButton(
                  child: Text("+1S"),
                  onPressed: _incrementTimer_1S,
                ),
                RaisedButton(
                  child: Text("TESTTEST"),
                  onPressed: () {
                    Vibration.vibrate(duration: 500);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("Reset"),
                  onPressed: _resetTimer,
                ),
                RaisedButton(
                  child: Text("Stop/Re"),
                  onPressed: _stopTimer,
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Text("Player1 X: $_missPlayer1", style: TextStyle(fontSize: 30)),
            Text("Player2 X: $_missPlayer2", style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
// ##### Finish:battle_timer.dart#####
// ############################################################################

// #########################################################################
// ##### Start:my_painter.dart#####
// import 'dart:math';
// import 'dart:ui';
class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;

  MyPainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.butt
      // ..style = PaintingStyle.stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
// ##### Finish:my_painter.dart#####
// ############################################################################
