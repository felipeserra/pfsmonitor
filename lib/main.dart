import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:pfsmonitor/views/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static Map<int, Color> color = {
    50: Color.fromRGBO(0, 84, 53, .1),
    100: Color.fromRGBO(0, 84, 53, .2),
    200: Color.fromRGBO(0, 84, 53, .3),
    300: Color.fromRGBO(0, 84, 53, .4),
    400: Color.fromRGBO(0, 84, 53, .5),
    500: Color.fromRGBO(0, 84, 53, .6),
    600: Color.fromRGBO(0, 84, 53, .7),
    700: Color.fromRGBO(0, 84, 53, .8),
    800: Color.fromRGBO(0, 84, 53, .9),
    900: Color.fromRGBO(0, 84, 53, 1),
  };
  MaterialColor _primaryColor = MaterialColor(0xFF005499, color);
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: MaterialApp(
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        title: 'PFS Monitor',
        theme: ThemeData(primaryColor: _primaryColor),
        home: Home(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
