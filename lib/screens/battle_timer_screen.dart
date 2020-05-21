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
    BattleTimerData battleTimerData =
        Provider.of<BattleTimerData>(context, listen: false);

    // TEST
    print('TEST2');
    print(Provider.of<BattleTimerData>(context, listen: false).turnPlayerName);
    // TEST

    if (!battleTimerData.isStarted) {
      const oneSec = const Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            battleTimerData =
                Provider.of<BattleTimerData>(context, listen: false);

            // TEST
            print('TEST3');
            print(Provider.of<BattleTimerData>(context, listen: false)
                .turnPlayerName);
            // TEST

            if (!battleTimerData.isStopped) {
              // 0 になったとき
              if (battleTimerData.currentTime < 1) {
                timer.cancel();
                battleTimerData.resetBattleTimer();

                _resetCurrentTime();
                battleTimerData.timeOver();

                if (battleTimerData.turnPlayerName == kPlayer1Name) {
                  battleTimerData.missPlayer1();
                } else {
                  battleTimerData.missPlayer2();
                }
                battleTimerData.changePlayer();
                _startTimer();
                // 以下は通常処理
              } else {
                battleTimerData.decrementTime1s();
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
    battleTimerData.startTimer();
    // TEST
    print('TESTTES');
    print(Provider.of<BattleTimerData>(context, listen: false).turnPlayerName);
    // TEST
  }

  void _changePlayer() {
    Provider.of<BattleTimerData>(context, listen: false).changePlayer();
    Vibration.vibrate(duration: 100);
    _resetCurrentTime();
    _startTimer();
  }

  void _changeTimerS(int i) {
    setState(() {
      Provider.of<BattleTimerData>(context, listen: false)
          .changeDefaultTimer(i);
      _resetCurrentTime();
    });
  }

  // currentTimeをリセット
  void _resetCurrentTime() {
    Provider.of<BattleTimerData>(context, listen: false).restartBattleTimer();
    _initTimer(
        Provider.of<BattleTimerData>(context, listen: false).defaultTime);
  }

  void _resetTimer() {
    setState(() {
      _timer.cancel();
      Provider.of<BattleTimerData>(context, listen: false).resetBattleTimer();
      _resetCurrentTime();
    });
  }

  void _stopTimer() {
    setState(() {
      Provider.of<BattleTimerData>(context, listen: false).stopButton();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TEST
    print('TEST1');
    print(Provider.of<BattleTimerData>(context, listen: false).turnPlayerName);
    // TEST

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
                          child: Text('-1S'),
                          // 【変数】
                          onPressed: () => _changeTimerS(-1),
                        ),
                        const SizedBox(width: 10.0),
                        RaisedButton(
                          child: Text('+1S'),
                          // 【変数】
                          onPressed: () {
                            _changeTimerS(1);
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
