import 'package:battletimer/models/battle_timer_data.dart';
import 'package:battletimer/screens/battle_timer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BattleTimerData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.teal[400],
        ),
        home: BattleTimer(),
      ),
    );
  }
}
