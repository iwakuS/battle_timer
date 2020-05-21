import 'dart:async';
import 'dart:ui';

import 'package:battletimer/modules/timer_painter.dart';
import 'package:battletimer/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class BattleTimer extends StatefulWidget {
  @override
  _BattleTimerState createState() => _BattleTimerState();
}

class _BattleTimerState extends State<BattleTimer>
    with TickerProviderStateMixin {
  // Setting Time(sec)
  int _startDefault = kStartDefaultTime;
  int _currentTime;

  // Setting Player data
  int _missNumberPlayer1;
  int _missNumberPlayer2;

  var _colorBar = <Color>[
    kPlayer1Color,
    kPlayer2Color,
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
    _missNumberPlayer1 = 0;
    _missNumberPlayer2 = 0;
  }

  void _initTimer() {
    _currentTime = _startDefault;
    setState(() {
      percentage = 0.0;
      newPercentage = 0.0;
      _interval = 100 / _currentTime;
      _onTimer(_currentTime);
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
              if (_currentTime < 1) {
                timer.cancel();
                //add for Timer = 0
                _initTimer();
                _isStarted = false;
                _startTimer();
                if (_colorPlayerNumber < 1) {
                  _colorPlayerNumber += 1;
                  _missNumberPlayer1 += 1;
                } else {
                  _colorPlayerNumber = 0;
                  _missNumberPlayer2 += 1;
                }
              } else {
                _currentTime = _currentTime - 1;
                _onTimer(_currentTime);
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
      _missNumberPlayer1 = 0;
      _missNumberPlayer2 = 0;
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Player$_turnPlayer",
                  style: kPlayerNameTextStyle,
                ),
                const SizedBox(height: 40.0),
                Container(
                  height: 280.0,
                  width: 280.0,
                  child: CustomPaint(
                    foregroundPainter: TimerPainter(
                        lineColor: _colorBar[_colorPlayerNumber],
                        completeColor: Colors.grey,
                        completePercent: percentage,
                        width: 65.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.white,
                        textColor: Colors.black,
                        splashColor: Colors.tealAccent,
                        shape: CircleBorder(),
                        child: Text(
                          "$_time",
                          style: kCurrentTimeTextStyle,
                          textAlign: TextAlign.center,
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
                    const SizedBox(width: 10.0),
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
                    const SizedBox(width: 10.0),
                    RaisedButton(
                      child: Text("Stop/Re"),
                      onPressed: _stopTimer,
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Text("Player1 X: $_missNumberPlayer1",
                    style: TextStyle(fontSize: 30)),
                Text("Player2 X: $_missNumberPlayer2",
                    style: TextStyle(fontSize: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
