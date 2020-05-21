import 'package:battletimer/utilities/constants.dart';

class BattleTimer {
  int defaultTime;
  int currentTime;
  final String player1Name;
  final String player2Name;
  int missNumberPlayer1;
  int missNumberPlayer2;
  // プレイヤーごとのColorはここにはいらない？ターンプレイヤーが分かれば、簡単
  String turnPlayerName;
  bool isStarted;
  bool isStopped;

  BattleTimer({
    this.defaultTime = kStartDefaultTime,
    this.currentTime = kStartDefaultTime,
    this.player1Name = kPlayer1Name,
    this.player2Name = kPlayer2Name,
    this.missNumberPlayer1 = 0,
    this.missNumberPlayer2 = 0,
    this.turnPlayerName = kPlayer1Name,
    this.isStarted = false,
    this.isStopped = false,
  });

  void toggleStarted() {
    isStarted = !isStarted;
  }

  void toggleStopped() {
    isStopped = !isStopped;
  }
}
