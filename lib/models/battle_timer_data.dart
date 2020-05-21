import 'dart:async';
import 'dart:ui';

import 'package:battletimer/utilities/constants.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'battle_timer.dart';

class BattleTimerData extends ChangeNotifier {
  // 内部変数にする必要はない？
  BattleTimer _battleTimer = BattleTimer();

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

  int get missNumberPlayer1 {
    return _battleTimer.missNumberPlayer1;
  }

  int get missNumberPlayer2 {
    return _battleTimer.missNumberPlayer1;
  }

  int get currentTime {
    return _battleTimer.currentTime;
  }

  int get defaultTime {
    return _battleTimer.defaultTime;
  }

  bool get isStarted {
    return _battleTimer.isStarted;
  }

  bool get isStopped {
    return _battleTimer.isStopped;
  }

  String get turnPlayerName {
    return _battleTimer.turnPlayerName;
  }

  void timeOver() {
    _battleTimer.toggleStarted();
    notifyListeners();
  }

  void missPlayer1() {
    _battleTimer.missNumberPlayer1++;
    notifyListeners();
  }

  void missPlayer2() {
    _battleTimer.missNumberPlayer1++;
    notifyListeners();
  }

  void decrementTime1s() {
    _battleTimer.currentTime--;
    notifyListeners();
  }

  void startTimer() {
    _battleTimer.toggleStarted();
    notifyListeners();
  }

  void updateDefaultTimer(int i) {
    _battleTimer.defaultTime += i;
    notifyListeners();
  }

  void resetBattleTimer() {
    _battleTimer = BattleTimer(
      defaultTime: _battleTimer.defaultTime,
      currentTime: _battleTimer.defaultTime,
    );
    notifyListeners();
  }

  void changePlayer() {
    if (_battleTimer.turnPlayerName == kPlayer1Name) {
      _battleTimer.turnPlayerName = kPlayer2Name;
    } else {
      _battleTimer.turnPlayerName = kPlayer1Name;
    }
    notifyListeners();
  }

  void stopButton() {
    _battleTimer.toggleStopped();
    notifyListeners();
  }
}
