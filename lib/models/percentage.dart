//import 'dart:async';
//import 'dart:ui';
//
//import 'package:battletimer/utilities/constants.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:provider/provider.dart';
//import 'package:vibration/vibration.dart';
//
//import 'battle_timer_data.dart';
//
//class Percentage extends StatefulWidget {
//  @override
//  _PercentageState createState() => _PercentageState();
//}
//
//class _PercentageState extends State<Percentage>  with TickerProviderStateMixin {
//  double percentage = 0.0;
//  double newPercentage = 0.0;
//  AnimationController percentageAnimationController;
//  Timer _timer;
//  double _interval = 0.0;
//
//  @override
//  void initState() {
//    super.initState();
//    _initTimer(kStartDefaultTime);
//  }
//
//  void _initTimer(int setTime) {
//    setState(() {
//      percentage = 0.0;
//      newPercentage = 0.0;
//      _interval = 100 / setTime;
//    });
//    percentageAnimationController =
//    AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
//      ..addListener(() {
//        setState(() {
//          percentage = lerpDouble(percentage, newPercentage,
//              percentageAnimationController.value);
//        });
//      });
//  }
//
//  void _restartTimer() {
//    Provider.of<BattleTimerData>(context, listen: false).restartBattleTimer();
//    _initTimer(
//        Provider.of<BattleTimerData>(context, listen: false).defaultTime);
//  }
//
//  void _startTimer() {
//    BattleTimerData battleTimerData =
//    Provider.of<BattleTimerData>(context, listen: false);
//
//    if (!battleTimerData.isStarted) {
//      const oneSec = const Duration(seconds: 1);
//      _timer = Timer.periodic(
//        oneSec,
//            (Timer timer) => setState(
//              () {
//            if (!battleTimerData.isStopped) {
//              // 0 になったとき
//              if (battleTimerData.currentTime < 1) {
//                timer.cancel();
//                battleTimerData.resetBattleTimer();
//
//                _restartTimer();
//                battleTimerData.timeOver();
//
//                if (battleTimerData.turnPlayerName == kPlayer1Name) {
//                  battleTimerData.missPlayer1();
//                } else {
//                  battleTimerData.missPlayer2();
//                }
//                battleTimerData.changePlayer();
//                _startTimer();
//              } else {
//                battleTimerData.decrementTime1s();
//                percentage = newPercentage;
//                newPercentage += _interval;
//                if (newPercentage > 100.0) {
//                  percentage = 0.0;
//                  newPercentage = 0.0;
//                }
//                percentageAnimationController.forward(from: 0.0);
//              }
//            }
//          },
//        ),
//      );
//    }
//    battleTimerData.startTimer();
//  }
//
//  void _changePlayer() {
//    Provider.of<BattleTimerData>(context, listen: false).changePlayer();
//    Vibration.vibrate(duration: 100);
//    _restartTimer();
//    _startTimer();
//  }
//
//  void _changeTimerS(int i) {
//    setState(() {
//      Provider.of<BattleTimerData>(context, listen: false)
//          .changeDefaultTimer(i);
//      _restartTimer();
//    });
//  }
//
//  void _resetTimer() {
//    setState(() {
//      _timer.cancel();
//      Provider.of<BattleTimerData>(context, listen: false).resetBattleTimer();
//      _restartTimer();
//    });
//  }
//
//  void _stopTimer() {
//    setState(() {
//      Provider.of<BattleTimerData>(context, listen: false).stopButton();
//    });
//  }
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
