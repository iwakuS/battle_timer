import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'battle_timer.dart';

class BattleTimerData extends ChangeNotifier {
  // 内部変数にする必要はない？
  BattleTimer _battleTimer = BattleTimer();

  int get missNumberPlayer1 {
    return _battleTimer.missNumberPlayer1;
  }

  int get missNumberPlayer2 {
    return _battleTimer.missNumberPlayer2;
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
    _battleTimer.isStarted = false;
    notifyListeners();
  }

  void missPlayer1() {
    _battleTimer.missNumberPlayer1++;
    notifyListeners();
  }

  void missPlayer2() {
    _battleTimer.missNumberPlayer2++;
    notifyListeners();
  }

  void decrementTime1s() {
    _battleTimer.currentTime--;
    notifyListeners();
  }

  // 個別の一回一回の話
  void startTimer() {
    _battleTimer.isStarted = true;
    notifyListeners();
  }

  void changeDefaultTimer(int i) {
    _battleTimer.defaultTime += i;
    if (!_battleTimer.isStarted) {
      _battleTimer.currentTime = _battleTimer.defaultTime;
    }
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
    _battleTimer.toggleTurnPlayer();
    notifyListeners();
  }

  void stopButton() {
    _battleTimer.toggleStopped();
    notifyListeners();
  }

  void restartBattleTimer() {
    _battleTimer.currentTime = _battleTimer.defaultTime;
    //_battleTimer.isStarted = true;
    notifyListeners();
  }
}
