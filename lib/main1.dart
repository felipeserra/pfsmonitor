import 'package:flutter/material.dart';
import 'package:pfsmonitor/appurl.dart';
import 'package:pfsmonitor/listscreen.dart';
import 'package:pfsmonitor/statscounter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  MaterialColor PrimaryColor = MaterialColor(0xFF005499, color);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PFS Monitor',
      theme: ThemeData(
        primarySwatch: PrimaryColor,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListScreen();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Image.asset("images/logo.png"),
  //     ),
  //     body: Column(
  //       children: <Widget>[
  //         Divider(),
  //         StatsCounter(
  //           title: "APP Monitorado",
  //           size: 150,
  //           count: 4,
  //         ),
  //         Divider(),
  //         Container(
  //           height: (MediaQuery.of(context).size.height - 530 / 2),
  //           child: new ListView(
  //             //padding: const EdgeInsets.all(16),
  //             scrollDirection: Axis.vertical,
  //             children: <Widget>[
  //               StatItem(
  //                 item:
  //                     Item(name: "Enzimais", url: "http://www.enzimais.com.br"),
  //               ),
  //               StatItem(
  //                 item: Item(name: "PdPoint", url: "http://www.pdpoint.com.br"),
  //               ),
  //               StatItem(
  //                 item: Item(
  //                     name: "PSPReport", url: "https://www.pspreports.com.br/"),
  //               ),
  //               StatItem(
  //                 item: Item(
  //                     name: "Programa Mais",
  //                     url: "http://www.programamais.com.br"),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _incrementCounter,
  //       tooltip: 'Adicionar',
  //       child: Icon(Icons.add),
  //     ),
  //   );
  // }
}
