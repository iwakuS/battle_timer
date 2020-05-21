import 'dart:async';
import 'dart:ui';

import 'package:battletimer/models/battle_timer_data.dart';
import 'package:battletimer/modules/timer_painter.dart';
import 'package:battletimer/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class BattleTimer extends StatefulWidget {
  @override
  _BattleTimerState createState() => _BattleTimerState();
}

class _BattleTimerState extends State<BattleTimer>
    with TickerProviderStateMixin {
  // Setting Timer
  double percentage = 0.0;
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;
  Timer _timer;
  double _interval = 0.0;

  @override
  void initState() {
    super.initState();
    _initTimer(kStartDefaultTime);
  }

  // Provider系は引数にすればいい？

  void _initTimer(int setTime) {
    setState(() {
      percentage = 0.0;
      newPercentage = 0.0;
      _interval = 100 / setTime;
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

  void _startTimer() {
    //BattleTimerData battleTimerData = Provider.of<BattleTimerData>(context);
    if (!Provider.of<BattleTimerData>(context, listen: false).isStarted) {
      const oneSec = const Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (!Provider.of<BattleTimerData>(context, listen: false)
                .isStopped) {
              if (Provider.of<BattleTimerData>(context, listen: false)
                      .currentTime <
                  1) {
                timer.cancel();
                //add for Timer = 0
                _initTimer(Provider.of<BattleTimerData>(context, listen: false)
                    .defaultTime);
                Provider.of<BattleTimerData>(context, listen: false).timeOver();
                _startTimer();
                if (Provider.of<BattleTimerData>(context, listen: false)
                        .turnPlayerName ==
                    kPlayer1Name) {
                  Provider.of<BattleTimerData>(context, listen: false)
                      .missPlayer1();
                } else {
                  Provider.of<BattleTimerData>(context, listen: false)
                      .missPlayer2();
                }
                Provider.of<BattleTimerData>(context, listen: false)
                    .changePlayer();
              } else {
                Provider.of<BattleTimerData>(context, listen: false)
                    .decrementTime1s();
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
    Provider.of<BattleTimerData>(context, listen: false).startTimer();
  }

  void _changePlayer() {
    _initTimer(
        Provider.of<BattleTimerData>(context, listen: false).defaultTime);
    _startTimer();
  }

  void _incrementTimer_1S() {
    setState(() {
      Provider.of<BattleTimerData>(context, listen: false)
          .updateDefaultTimer(1);
      _initTimer(
          Provider.of<BattleTimerData>(context, listen: false).defaultTime);

      print(
          '${Provider.of<BattleTimerData>(context, listen: false).defaultTime}');
    });
  }

  void _decrementTimer_1S() {
    setState(() {
      Provider.of<BattleTimerData>(context, listen: false)
          .updateDefaultTimer(-1);
      _initTimer(
          Provider.of<BattleTimerData>(context, listen: false).defaultTime);
    });
  }

  void _resetTimer() {
    setState(() {
      _timer.cancel();
      Provider.of<BattleTimerData>(context, listen: false).resetBattleTimer();

      _initTimer(
          Provider.of<BattleTimerData>(context, listen: false).defaultTime);
    });
  }

  void _stopTimer() {
    setState(() {
      Provider.of<BattleTimerData>(context, listen: false).stopButton();
    });
  }

  @override
  Widget build(BuildContext context) {
    // BattleTimerData battleTimerData = Provider.of<BattleTimerData>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FittedBox(
            child: Consumer<BattleTimerData>(
              builder: (context, battleTimerData, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // 【変数】
                    Text(
                      '${battleTimerData.turnPlayerName}',
                      style: kPlayerNameTextStyle,
                    ),
                    const SizedBox(height: 40.0),
                    Container(
                      height: 280.0,
                      width: 280.0,
                      child: CustomPaint(
                        foregroundPainter: TimerPainter(
                          // 【変数】
                          lineColor:
                              (battleTimerData.turnPlayerName == kPlayer1Name)
                                  ? Colors.red[500]
                                  : Colors.lightBlue,
                          completeColor: Colors.grey,
                          completePercent: percentage,
                          width: 65.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Colors.white,
                            textColor: Colors.black,
                            splashColor: Colors.tealAccent,
                            shape: CircleBorder(),
                            child: Text(
                              // 【変数】
                              "${battleTimerData.currentTime}",
                              style: kCurrentTimeTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            // 【変数】
                            onPressed: () => battleTimerData.isStarted
                                ? _changePlayer()
                                : _startTimer(),
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
                          // 【変数】
                          onPressed: _decrementTimer_1S,
                        ),
                        const SizedBox(width: 10.0),
                        RaisedButton(
                          child: Text("+1S"),
                          // 【変数】
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
                          // 【変数】
                          onPressed: _resetTimer,
                        ),
                        const SizedBox(width: 10.0),
                        RaisedButton(
                          child: Text("Stop/Re"),
                          // 【変数】
                          onPressed: _stopTimer,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    // 【変数】
                    Text('Player1 ✖: ${battleTimerData.missNumberPlayer1}',
                        style: TextStyle(fontSize: 30)),
                    // 【変数】
                    Text('Player2 ✖: ${battleTimerData.missNumberPlayer2}',
                        style: TextStyle(fontSize: 30)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
